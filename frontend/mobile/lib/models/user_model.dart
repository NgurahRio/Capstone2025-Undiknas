class User {
  final int id_user;
  final String userName;
  final String email;
  final String password;

  User({
    required this.id_user,
    required this.userName,
    required this.email,
    required this.password,
  });

  static User? currentUser;
}

final List<User> users = [
  User(
    id_user: 1,
    userName: "Riyo",
    email: "riyo@gmail.com",
    password: "12345678",
  ),
  User(
    id_user: 2,
    userName: "Wilson",
    email: "wdc@gmail.com",
    password: "12345678",
  ),
];