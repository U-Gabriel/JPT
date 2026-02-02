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
      _firstName = _userData?['firstname'];
      _user = _userData;
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
      _user = null;
    }
  }

  String? _firstName;
  String? get firstName => _firstName;

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
        _firstName = data['firstname'];
        _userData = data;
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _accessToken!);
        await prefs.setString('id_person', _userId!);
        await prefs.setString('data', jsonEncode(_userData));

        notifyListeners();
        print("✅ Login réussi pour $_firstName ($_userId)");
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
      final json = jsonDecode(response.body);
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

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

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
