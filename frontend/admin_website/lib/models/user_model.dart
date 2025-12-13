import 'package:admin_website/models/role_model.dart';

class User {
  final int id_user;
  final Role roleId;
  final String userName;
  final String email;
  final String password;

  User({
    required this.id_user,
    required this.roleId,
    required this.userName,
    required this.email,
    required this.password,
  });

  static User? currentUser;
}

final List<User> users = [
  User(
    id_user: 1,
    roleId: roles.firstWhere((r) => r.id_role == 1),
    userName: "Admin",
    email: "admin@gmail.com",
    password: "12345678",
  ),
  User(
    id_user: 2,
    roleId: roles.firstWhere((r) => r.id_role == 2),
    userName: "Riyo",
    email: "riyo@gmail.com",
    password: "12345678",
  ),
  User(
    id_user: 3,
    roleId: roles.firstWhere((r) => r.id_role == 2),
    userName: "Wilson",
    email: "wdc@gmail.com",
    password: "12345678",
  ),
];