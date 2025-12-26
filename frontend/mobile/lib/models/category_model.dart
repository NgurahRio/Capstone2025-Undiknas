import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/api.dart';

class Category {
  final int id_category;
  final String name;

  Category({
    required this.id_category, 
    required this.name
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id_category: json['id_categories'],
      name: json['name'],
    );
  }
}

Future<List<Category>> getCategories() async {
  final response = await http.get(
    Uri.parse('$baseUrl/categories'),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode != 200) {
    throw Exception('Gagal mengambil category');
  }
  final decoded = jsonDecode(response.body);
  final List list = decoded['data'];
  return list.map((e) => Category.fromJson(e)).toList();
}


final List<Category> categories = [
  Category(id_category: 1, name: "Adventure"),
  Category(id_category: 2, name: "Culture"),
];