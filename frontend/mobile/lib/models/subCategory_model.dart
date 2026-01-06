import 'dart:convert';

import 'package:mobile/api.dart';
import 'package:mobile/models/category_model.dart';
import 'package:http/http.dart' as http;

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
      categoryId: Category.fromJson(json['category'])
    );
  }
}

Future<List<SubCategory>> getSubCategories(
  List<Category> categories,
) async {

  final response = await http.get(
    Uri.parse('$baseUrl/subcategories'),
  );

  print(response.body);

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