import 'dart:convert';
import 'dart:io';
import 'package:mobile/api.dart';
import 'package:mobile/models/role_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id_user;
  final Role roleId;
  final String username;
  final String email;
  final String? password;
  final String image;

  User({
    required this.id_user,
    required this.roleId,
    required this.username,
    required this.email,
    this.password,
    required this.image,
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
      image: json['image'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'username': username,
      'email': email,
      'image': image,
    };
  }

  static User? currentUser;
}

Future<User> updateProfile({
  String? username,
  String? oldPassword,
  String? newPassword,
  File? imageFile,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final uri = Uri.parse("$baseUrl/user/profile");
  final request = http.MultipartRequest("PUT", uri);

  request.headers['Authorization'] = "Bearer $token";

  if (username != null && username.isNotEmpty) {
    request.fields['username'] = username;
  }

  if (newPassword != null && newPassword.isNotEmpty) {
    request.fields['password'] = newPassword;
    request.fields['old_password'] = oldPassword ?? '';
  }

  if (imageFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ),
    );
  }

  final streamedResponse = await request.send();
  final responseBody = await streamedResponse.stream.bytesToString();

  final decoded = jsonDecode(responseBody);

  if (streamedResponse.statusCode != 200) {
    throw decoded['error'] ?? 'Gagal update profile';
  }

  final updatedUser = User.fromJson(decoded['user']);

  User.currentUser = updatedUser;

  return updatedUser;
}

final List<User> users = [
  User(
    id_user: 1,
    roleId: roles.firstWhere((r) => r.id_role == 1),
    username: "Admin",
    email: "admin@gmail.com",
    password: "12345678",
    image: ""
  ),
  User(
    id_user: 2,
    roleId: roles.firstWhere((r) => r.id_role == 2),
    username: "Riyo",
    email: "riyo@gmail.com",
    password: "12345678",
    image: "assets/profile.jpg"
  ),
  User(
    id_user: 3,
    roleId: roles.firstWhere((r) => r.id_role == 2),
    username: "Wilson",
    email: "wdc@gmail.com",
    password: "12345678",
    image: "assets/profile.jpg"
  ),
];