import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubPackage {
  final int id_subPackage;
  final String name;
  final String icon;

  SubPackage({
    required this.id_subPackage,
    required this.name,
    required this.icon
  });

  factory SubPackage.fromJson(Map<String, dynamic> json) {
    return SubPackage(
      id_subPackage: json['id_subpackage'],
      name: json['jenispackage'],
      icon: json['image'] ?? '',
    );
  }
}

Future<List<SubPackage>> getSubPackages() async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/subpackage'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal ambil sub package');
  }

  final jsonData = jsonDecode(response.body);
  final List list = jsonData['data'];

  return list.map((e) => SubPackage.fromJson(e)).toList();
}

final List<SubPackage> subPackages = [
  SubPackage(
    id_subPackage: 1, 
    name: "Solo Trip", 
    icon: "assets/icons/solo.png"
  ),
  SubPackage(
    id_subPackage: 2, 
    name: "Romantic Gateway", 
    icon: "assets/icons/romantic.png"
  ),
  SubPackage(
    id_subPackage: 3, 
    name: "Family Package", 
    icon: "assets/icons/family.png"
  ),
  SubPackage(
    id_subPackage: 4, 
    name: "Group Tour", 
    icon: "assets/icons/group.png"
  ),
];