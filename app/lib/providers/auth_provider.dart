import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:app/app_config.dart';

import '../services/api_client.dart';

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

    ApiClient().onForceLogout = () {
      _isAuthenticated = false;
      _accessToken = null;
      _userId = null;
      _userData = null;
      _user = null;
      _pseudo = null;
      notifyListeners();
    };
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final data = json['data'];

        _accessToken = data['token'];
        final String refreshToken = data['refresh_token']; // Récupération du refresh
        _userId = data['id_person'].toString();
        _pseudo = data['pseudo'];
        _userData = data;
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _accessToken!);
        await prefs.setString('refresh_token', refreshToken); // Stockage local
        await prefs.setString('id_person', _userId!);
        await prefs.setString('data', jsonEncode(_userData));

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
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

      if (json['status']?.toString().toUpperCase() == "OK") {
        final data = json['data'];
        final userData = data['user'];

        _accessToken = userData['token']?.toString();
        final String? refreshToken = userData['refresh_token']?.toString();
        _userId = userData['id_person']?.toString();
        _pseudo = userData['pseudo']?.toString();

        _userData = userData;
        _user = userData;
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        if (_accessToken != null) await prefs.setString('token', _accessToken!);
        if (refreshToken != null) await prefs.setString('refresh_token', refreshToken);
        if (_userId != null) await prefs.setString('id_person', _userId!);
        await prefs.setString('data', jsonEncode(userData));

        notifyListeners();
        return {"success": true, "message": "Compte validé et connecté !"};
      } else {
        return {"success": false, "message": json['message'] ?? "Code incorrect."};
      }
    } catch (e) {
      return {"success": false, "message": "Erreur technique : $e"};
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
