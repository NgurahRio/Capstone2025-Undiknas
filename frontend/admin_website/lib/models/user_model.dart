import 'package:admin_website/models/role_model.dart';
import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final int id_user;
  final Role roleId;
  final String username;
  final String email;
  final String? password;
  final String? image;

  User({
    required this.id_user,
    required this.roleId,
    required this.username,
    required this.email,
    this.password,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final int roleIdFromApi = json['roleId'];

    final Role role = roles.firstWhere(
      (r) => r.id_role == roleIdFromApi,
      orElse: () => Role(
        id_role: 0,
        role_name: 'unknown',
      ),
    );

    return User(
      id_user: json['id_users'],
      username: json['username'],
      email: json['email'],
      roleId: role,
    );
  }

  static User? currentUser;
}

Future<List<User>> getUsers() async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/users'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal ambil user');
  }

  final jsonData = jsonDecode(response.body);
  final List list = jsonData['data'];

  return list.map((e) => User.fromJson(e)).toList();
}

Future<void> deleteUser (int idUser) async {
  final token = html.window.localStorage['token'];

  final response = await http.delete(
    Uri.parse('$baseUrl/admin/users/$idUser'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus user');
  }
}

final List<User> users = [
  User(
    id_user: 1,
    roleId: roles.firstWhere((r) => r.id_role == 1),
    username: "Admin",
    email: "admin@gmail.com",
    password: "12345678",
  ),
  User(
    id_user: 2,
    roleId: roles.firstWhere((r) => r.id_role == 2),
    username: "Riyo",
    email: "riyo@gmail.com",
    password: "12345678",
  ),
  User(
    id_user: 3,
    roleId: roles.firstWhere((r) => r.id_role == 2),
    username: "Wilson",
    email: "wdc@gmail.com",
    password: "12345678",
  ),
];