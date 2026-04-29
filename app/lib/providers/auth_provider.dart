import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:app/app_config.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _accessToken;
  String? _userId;

  Map<String, dynamic>? _userData;


  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get accessToken => _accessToken;

  Map<String, dynamic>? get userData => _userData;

  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;

  bool get isLoggedIn => _isAuthenticated;


  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('id_person');
    final userDataJson = prefs.getString('data');


    if (token != null && userId != null && userDataJson != null) {
      _isAuthenticated = true;
      _accessToken = token;
      _userId = userId;
      _userData = jsonDecode(userDataJson);
      notifyListeners();
      _pseudo = _userData?['pseudo'];
      _user = _userData;
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
      _user = null;
    }
  }

  String? _pseudo;
  String? get pseudo => _pseudo;

  Future<bool> login(String pseudo, String password) async {
    final url = Uri.parse(AppConfig.loginEndpoint);
    print("➡️ Tentative login vers $url avec pseudo=$pseudo");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pseudo': pseudo, 'password': password}),
      );

      print("📩 Status: ${response.statusCode}");
      print("📩 Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final data = json['data'];

        _accessToken = data['token'];
        _userId = data['id_person'].toString();
        _pseudo = data['pseudo'];
        _userData = data;
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _accessToken!);
        await prefs.setString('id_person', _userId!);
        await prefs.setString('data', jsonEncode(_userData));

        notifyListeners();
        print("✅ Login réussi pour $_pseudo ($_userId)");
        return true;
      } else {
        print("❌ Login échoué: ${response.statusCode}");
        return false;
      }
    } catch (e, stack) {
      debugPrint("💥 Exception login: $e");
      debugPrint("$stack");
      return false;
    }
  }


  Future<void> logout() async {
    _isAuthenticated = false;
    _accessToken = null;
    _userId = null;
    _userData = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }


  Future<bool> signup({
    required String email,
    required String pseudo,
    required String password,
    required String firstname,
    String? surname,
    String? numberPhone,
  }) async {
    final url = Uri.parse(AppConfig.signupEndpoint);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mail': email,
        'pseudo': pseudo,
        'password': password,
        'firstname': firstname,
        'surname': surname ?? '',
        'number_phone': numberPhone ?? '',
      }),
    );

    print("Signup status: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      /*final json = jsonDecode(response.body);
      final data = json['data'];

      _isAuthenticated = true;
      _userId = data['id_person'].toString();
      _firstName = data['firstname'];
      _accessToken = data['token'];
      _userData = data;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id_person', _userId!);
      await prefs.setString('firstName', _firstName!);
      await prefs.setString('token', _accessToken!);
      await prefs.setString('data', jsonEncode(_userData));

      notifyListeners();*/
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendValidationMail(String email) async {
    final url = Uri.parse(AppConfig.sendMailEndpoint);
    try {
      print("➡️ Envoi mail à : $url pour $email"); // Debug
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"mail": email}),
      ).timeout(const Duration(seconds: 10));


      // Vérifie si le status est 200 OU si le JSON contient "OK"
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['status'] == "OK";
      }
      return false;
    } catch (e) {
      print("💥 Erreur lors de l'appel sendMail: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> validateAccount({
    required String pseudo,
    required String mail,
    required String password,
    required String code,
  }) async {
    final url = Uri.parse(AppConfig.validateAccountEndpoint);
    try {
      print("➡️ Envoi validation à $url");
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "pseudo": pseudo,
          "mail": mail,
          "password": password,
          "code": code,
        }),
      );

      final json = jsonDecode(response.body);

      // On vérifie le status de manière plus flexible (insensible à la casse)
      if (json['status']?.toString().toUpperCase() == "OK") {
        final data = json['data'];

        // 🚨 LA CORRECTION EST ICI : On récupère l'objet 'user'
        final userData = data['user'];

        print("--- DEBUG VALIDATION ACCOUNT ---");
        print("👤 UserData extrait: $userData");
        print("🔑 Token extrait: ${userData['token']}");
        print("--------------------------------");

        // ✅ On utilise maintenant 'userData' au lieu de 'data'
        _accessToken = userData['token']?.toString();
        _userId = userData['id_person']?.toString();
        _pseudo = userData['pseudo']?.toString();

        // On stocke l'intégralité pour le profil
        _userData = userData;
        _user = userData;
        _isAuthenticated = true;

        // ✅ Sauvegarde locale avec les bonnes variables
        final prefs = await SharedPreferences.getInstance();
        if (_accessToken != null) await prefs.setString('token', _accessToken!);
        if (_userId != null) await prefs.setString('id_person', _userId!);

        // On sauvegarde l'objet user complet
        await prefs.setString('data', jsonEncode(userData));

        notifyListeners();

        return {"success": true, "message": "Compte validé et connecté !"};
      }else {
        // Si le status n'est pas OK
        return {
          "success": false,
          "message": json['message'] ?? "Le code est incorrect ou a expiré."
        };
      }
    } catch (e, stack) {
      // C'est ici que tu tombes actuellement !
      // Regarde les logs pour voir l'erreur précise.
      print("💥 ERREUR CRITIQUE VALIDATION: $e");
      print(stack);
      return {"success": false, "message": "Erreur technique : $e"};
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    final url = Uri.parse(AppConfig.requestForgotPasswordResetEndpoint);

    try {

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mail': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        return json['status'] == "OK";
      }
      return false;
    } catch (e) {
      debugPrint("💥 Erreur Exception requête reset : $e");
      return false;
    }
  }


  Future<bool> verifyResetCode(String email, String code) async {
    final url = Uri.parse(AppConfig.requestConfimationSimpleForgotPasswordResetEndpoint);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mail': email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // On vérifie si l'API renvoie status OK et valid true
        return json['status'] == "OK" && json['data']['valid'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Erreur vérification code : $e");
      return false;
    }
  }

  Future<bool> finalizePasswordReset({
    required String email,
    required String code,
    required String newPassword
  }) async {
    final url = Uri.parse(AppConfig.requestModificationPasswordResetEndpoint);
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mail': email,
          'code': code,
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['status'] == "OK";
      }
      return false;
    } catch (e) {
      debugPrint("Erreur modification mot de passe : $e");
      return false;
    }
  }

  ///




  Future<bool> sendResetCodeByEmail(String email, String code) async {
    final url = Uri.parse(AppConfig.requestPasswordResetEndpoint);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'verificationCode': code}),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Erreur envoi mail : $e");
      return false;
    }
  }

  /// Just test for the moment
  Future<bool> resetPassword(String email, String newPassword) async {
    final url = Uri.parse(AppConfig.resetPasswordEndpoint);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': newPassword}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Erreur reset password : $e");
      return false;
    }
  }



}
