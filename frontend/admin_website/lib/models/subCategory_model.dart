import 'package:admin_website/models/category_model.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubCategory {
  final int id_subCategory;
  final String name;
  final Category categoryId;

  SubCategory({
    required this.id_subCategory,
    required this.name,
    required this.categoryId,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
  return SubCategory(
    id_subCategory: json['id_subcategories'],
    name: json['namesubcategories'],
    categoryId: json['category'] != null
        ? Category.fromJson(json['category'])
        : Category(
            id_category: json['categoriesId'],
            name: 'Unknown',
          ),
  );
}

}

Future<List<SubCategory>> getSubCategories(
  List<Category> categories,
) async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/subcategory'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List list = json['data'];

    return list
      .map((e) => SubCategory.fromJson(e))
      .toList();
  } else {
    throw Exception('Gagal mengambil subcategory');
  }
}

Future<SubCategory?> createSubCategory({
  required String name,
  required int categoryId,
  required List<Category> categories,
}) async {
  final token = html.window.localStorage['token'];

  final response = await http.post(
    Uri.parse('$baseUrl/admin/subcategory'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'namesubcategories': name,
      'categoriesId': categoryId,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final json = jsonDecode(response.body);
    return SubCategory.fromJson(json['data']);
  }

  return null;
}

Future<void> deleteSubCategory(int id) async {
  final token = html.window.localStorage['token'];

  final res = await http.delete(
    Uri.parse('$baseUrl/admin/subcategory/$id'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode != 200) {
    throw Exception('Gagal hapus subcategory');
  }
}

final List<SubCategory> subCategories = [
  SubCategory(
    id_subCategory: 1,
    name: "Luxury",
    categoryId: categories.firstWhere((c) => c.id_category == 1),
  ),
  SubCategory(
    id_subCategory: 2,
    name: "Budget",
    categoryId: categories.firstWhere((c) => c.id_category == 1),
  ),
  SubCategory(
    id_subCategory: 3,
    name: "Historical",
    categoryId: categories.firstWhere((c) => c.id_category == 2),
  ),
  SubCategory(
    id_subCategory: 4,
    name: "Art",
    categoryId: categories.firstWhere((c) => c.id_category == 2),
  ),
  SubCategory(
    id_subCategory: 5,
    name: "Museum",
    categoryId: categories.firstWhere((c) => c.id_category == 2),
  ),
  SubCategory(
    id_subCategory: 6,
    name: "Pura",
    categoryId: categories.firstWhere((c) => c.id_category == 2),
  ),
];