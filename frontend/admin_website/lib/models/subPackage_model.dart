import 'dart:html' as html;
import 'dart:typed_data';
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubPackage &&
          runtimeType == other.runtimeType &&
          id_subPackage == other.id_subPackage;

  @override
  int get hashCode => id_subPackage.hashCode;
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

Future<SubPackage?> createSubPackage({
  required String jenisPackage,
  required Uint8List iconBytes,
}) async {
  if (iconBytes.isEmpty) {
    throw Exception('Icon tidak boleh kosong');
  }

  final token = html.window.localStorage['token'];
  final uri = Uri.parse('$baseUrl/admin/subpackage');

  final request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer $token';
  request.fields['jenispackage'] = jenisPackage;

  request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        iconBytes,
        filename: 'icon.webp',
        contentType: http.MediaType('image', 'webp'),
      ),
    );

  final response = await request.send();

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Gagal membuat sub package');
  }

  final responseBody = await response.stream.bytesToString();
  final jsonData = jsonDecode(responseBody);

  return SubPackage.fromJson(jsonData['data']);
}

Future<bool> updateSubPackage({
  required int idSubPackage,
  required String jenisPackage,
  Uint8List? iconBytes,
}) async {
  final token = html.window.localStorage['token'];
  final uri = Uri.parse('$baseUrl/admin/subpackage/$idSubPackage');

  final request = http.MultipartRequest('PUT', uri);
  request.headers['Authorization'] = 'Bearer $token';
  request.fields['jenispackage'] = jenisPackage;

  if (iconBytes != null && iconBytes.isNotEmpty) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        iconBytes,
        filename: 'icon.webp',
        contentType: http.MediaType('image', 'webp'),
      ),
    );
  }

  final response = await request.send();

  if (response.statusCode != 200) {
    throw Exception('Gagal memperbarui sub package');
  }

  return true;
}

Future<void> deleteSubPackage(int idSubPackage) async {
  final token = html.window.localStorage['token'];

  final response = await http.delete(
    Uri.parse('$baseUrl/admin/subpackage/$idSubPackage'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus sub package');
  }
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