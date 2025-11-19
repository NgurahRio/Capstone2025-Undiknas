// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:admin_website/models/user_model.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _loggedUser;

  bool get isLoggedIn => _isLoggedIn;
  User? get loggedUser => _loggedUser;

  AuthService() {
    _isLoggedIn = html.window.localStorage['isLoggedIn'] == 'true';

    String? userId = html.window.localStorage['id_user'];

    if (userId != null) {
      _loggedUser = users.where(
        (u) => u.id_user.toString() == userId
      ).firstOrNull;
    }
  }

  bool login(String userName, String password) {
    User? foundUser = users.where(
      (u) => u.userName == userName && u.password == password
    ).firstOrNull;

    if (foundUser == null) return false;

    if (foundUser.roleid.id_role != 1) return false;

    _isLoggedIn = true;
    _loggedUser = foundUser;
    User.currentUser = foundUser;

    html.window.localStorage['isLoggedIn'] = 'true';
    html.window.localStorage['id_user'] = foundUser.id_user.toString();

    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _loggedUser = null;
    User.currentUser = null;

    html.window.localStorage.remove('isLoggedIn');
    html.window.localStorage.remove('id_user');

    notifyListeners();
  }
}
