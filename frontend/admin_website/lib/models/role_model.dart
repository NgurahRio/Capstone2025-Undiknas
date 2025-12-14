class Role  {
  final int id_role;
  final String role_name;

  Role({
    required this.id_role,
    required this.role_name,
  });
}

final List<Role> roles = [
  Role(
    id_role: 1, 
    role_name: "user"
  ),
  Role(
    id_role: 2, 
    role_name: "admin"
  ),
];