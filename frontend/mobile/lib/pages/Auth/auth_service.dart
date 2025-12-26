import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/api.dart';

class AuthService {
  static Future<User> register({
    required String username,
    required String email,
    required String password,
  }) async {

    final url = Uri.parse('$baseUrl/user/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();

      final userJson = data['user'];
      userJson['image'] = "";

      await prefs.setString('user', jsonEncode(userJson));

      final user = User.fromJson(userJson);
      User.currentUser = user;

      return user;
    } 
    else if (response.statusCode == 409) {
      throw Exception(data['error']);
    } 
    else {
      throw Exception(data['error'] ?? 'Registrasi gagal');
    }
  }

  static Future<User> login({
    required String identifier,
    required String password,
  }) async {

    final url = Uri.parse('$baseUrl/user/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', data['token']);

      final userJson = data['user'];
      userJson['image'] = userJson['image'] ?? '';

      await prefs.setString('user', jsonEncode(userJson));

      final user = User.fromJson(userJson);
      User.currentUser = user;

      await prefs.setInt('user_id', user.id_user);

      return user;
    }
    else if (response.statusCode == 401) {
      throw Exception('Username/email atau password salah');
    } 
    else {
      throw Exception(data['error'] ?? 'Login gagal');
    }
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('user_id');
    User.currentUser = null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final url = Uri.parse('$baseUrl/user/logout');
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }

    await clearSession();
  }
  
  static Future<User?> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    if (userString == null) return null;

    final userJson = jsonDecode(userString);
    final user = User.fromJson(userJson);
    User.currentUser = user;

    return user;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userString = prefs.getString('user');

    if (token == null || userString == null) return false;

    if (User.currentUser == null) {
      await loadUserFromStorage();
    }

    return true;
  }

}