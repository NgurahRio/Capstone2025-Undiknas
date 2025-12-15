// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/category'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal ambil categories');
  }

  final jsonData = jsonDecode(response.body);
  final List list = jsonData['data'];

  return list.map((e) => Category.fromJson(e)).toList();
}

Future<bool> createCategory(String name) async {
  final token = html.window.localStorage['token'];

  final response = await http.post(
    Uri.parse('$baseUrl/admin/category'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'name': name,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    debugPrint('Create category error: ${response.body}');
    return false;
  }
}

Future<void> deleteCategory(int idCategory) async {
  final token = html.window.localStorage['token'];

  final response = await http.delete(
    Uri.parse('$baseUrl/admin/category/$idCategory'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus category');
  }
}

final List<Category> categories = [
  Category(
    id_category: 1, 
    name: "Adventure"
  ),
  Category(
    id_category: 2, 
    name: "Culture"
  ),
];