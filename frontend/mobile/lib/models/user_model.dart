import 'package:mobile/models/role_model.dart';

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

  static User? currentUser;
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