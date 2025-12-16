// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';
import 'package:admin_website/api.dart';
import 'package:flutter/material.dart';
import 'package:admin_website/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _loggedUser;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  User? get loggedUser => _loggedUser;
  String? get token => _token;

  AuthService() {
    _token = html.window.localStorage['token'];
    final userJson = html.window.localStorage['user'];

    if (_token != null && userJson != null) {
      _loggedUser = User.fromJson(jsonDecode(userJson));
      User.currentUser = _loggedUser;
      _isLoggedIn = true;
    }
  }

  Future<bool> login(String loginId, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/admin/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "loginId": loginId,
        "password": password,
      }),
    );

    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body);

    _token = data['token'];
    _loggedUser = User.fromJson(data['user']);
    User.currentUser = _loggedUser;
    _isLoggedIn = true;

    html.window.localStorage['token'] = _token!;
    html.window.localStorage['user'] = jsonEncode(data['user']);

    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _loggedUser = null;
    _token = null;
    User.currentUser = null;

    html.window.localStorage.remove('token');
    html.window.localStorage.remove('user');

    notifyListeners();
  }
}

