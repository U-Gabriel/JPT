import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/app_config.dart';
import 'package:flutter/material.dart';
import 'package:app/main.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _client = http.Client();
  Function()? onForceLogout;

  // Variables pour gérer le verrouillage du rafraîchissement
  bool _isRefreshing = false;
  Future<bool>? _refreshFuture;

  Future<Map<String, String>> _getHeaders(Map<String, String>? customHeaders) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  // Modification ici : requestFn accepte désormais les nouveaux headers mis à jour
  Future<http.Response> _sendRequest(
      Future<http.Response> Function(Map<String, String> headers) requestFn,
      Map<String, String>? customHeaders,
      ) async {
    // 1. On génère les headers initiaux
    var currentHeaders = await _getHeaders(customHeaders);
    var response = await requestFn(currentHeaders);

    // On intercepte le 401 ET le 403
    if (response.statusCode == 401 || response.statusCode == 403) {
      print("🔄 Code ${response.statusCode} détecté. Tentative de rafraîchissement du token...");

      final isRefreshed = await _safeTokenRefresh();

      if (isRefreshed) {
        print("✅ Rafraîchissement réussi. Regénération des headers avec le nouveau token...");
        currentHeaders = await _getHeaders(customHeaders);

        // On rejoue la requête originale
        final retryResponse = await requestFn(currentHeaders);

        // Si même avec le nouveau token le serveur refuse (401 ou 403), on éjecte par sécurité
        if (retryResponse.statusCode == 401 || retryResponse.statusCode == 403) {
          print("🚨 Deuxième ${retryResponse.statusCode} consécutif après refresh. Déconnexion forcée.");
          await _forceLogout();
        }
        return retryResponse;
      } else {
        print("🚨 Échec critique du rafraîchissement (Refresh token expiré ou invalide). Déconnexion.");
        await _forceLogout();
        return http.Response(jsonEncode({'status': 'ERROR', 'message': 'Unauthorized'}), response.statusCode);
      }
    }
    return response;
  }

  Future<bool> _safeTokenRefresh() async {
    if (_isRefreshing) {
      print("⏳ Un rafraîchissement est déjà en cours, attente du résultat...");
      final result = await _refreshFuture;
      return result ?? false;
    }

    _isRefreshing = true;
    _refreshFuture = _handleTokenRefresh();

    final result = await _refreshFuture;

    _isRefreshing = false;
    _refreshFuture = null;
    return result ?? false;
  }

  Future<bool> _handleTokenRefresh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      print("🔑 Tentative de refresh avec le token local : $refreshToken");

      if (refreshToken == null || refreshToken.isEmpty) {
        print("❌ Aucun refresh token trouvé en local.");
        return false;
      }

      final url = Uri.parse(AppConfig.refreshEndpoint);

      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      print("📡 Réponse du serveur pour le Refresh : Code ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['status'] == "OK" || jsonBody['status'] == "success") {
          final data = jsonBody['data'];
          final newToken = data['token'];
          final newRefreshToken = data['refresh_token'];

          await prefs.setString('token', newToken);
          await prefs.setString('refresh_token', newRefreshToken);

          final userDataJson = prefs.getString('data');
          if (userDataJson != null) {
            final Map<String, dynamic> userData = jsonDecode(userDataJson);
            userData['token'] = newToken;
            userData['refresh_token'] = newRefreshToken;
            await prefs.setString('data', jsonEncode(userData));
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print("💥 Exception critique lors du rafraîchissement : $e");
      return false;
    }
  }

  Future<void> _forceLogout() async {
    print("🧹 Nettoyage des données locales de session...");
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (onForceLogout != null) {
      print("📢 Notification du AuthProvider pour vider l'état global.");
      onForceLogout!();
    }

    print("🚪 Redirection forcée vers l'accueil.");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
    });
  }

  // --- Méthodes réseau adaptées pour injecter dynamiquement les headers valides ---
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return _sendRequest((computedHeaders) async {
      return _client.get(url, headers: computedHeaders);
    }, headers);
  }

  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    return _sendRequest((computedHeaders) async {
      return _client.post(url, headers: computedHeaders, body: body);
    }, headers);
  }

  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body}) async {
    return _sendRequest((computedHeaders) async {
      return _client.patch(url, headers: computedHeaders, body: body);
    }, headers);
  }

  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body}) async {
    return _sendRequest((computedHeaders) async {
      return _client.delete(url, headers: computedHeaders, body: body);
    }, headers);
  }

  Future<http.Response> multipart({
    required String method,
    required Uri url,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    Map<String, String>? headers,
  }) async {
    return _sendRequest((computedHeaders) async {
      final request = http.MultipartRequest(method, url);
      request.headers.addAll(computedHeaders);
      request.fields.addAll(fields);
      request.files.addAll(files);
      final streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    }, headers);
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return "${AppConfig.serverBaseUrl}$path";
  }

}