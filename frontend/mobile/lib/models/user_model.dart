class User {
  final int id;
  final String userName;
  final String email;
  final String password;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
  });
}

final List<User> users = [
  User(
    id: 1,
    userName: "user",
    email: "john@example.com",
    password: "12345678",
  ),
  User(
    id: 2,
    userName: "admin",
    email: "admin@example.com",
    password: "admin123",
  ),
];