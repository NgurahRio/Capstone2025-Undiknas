import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SOS {
  final int id_sos;
  final String name;
  final String address;
  final String phone;

  SOS({
    required this.id_sos,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory SOS.fromJson(Map<String, dynamic> json) {
    return SOS(
      id_sos: json['id_sos'],
      name: json['name_sos'],
      address: json['alamat_sos'],
      phone: json['telepon'],
    );
  }
}

Future<List<SOS>> getSOS() async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/sos'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal ambil sos');
  }

  final jsonData = jsonDecode(response.body);
  final List list = jsonData['data'];

  return list.map((e) => SOS.fromJson(e)).toList();
}

Future<SOS?> createSOS({
  required String name,
  required String alamat,
  required String telepon,
}) async {
  final token = html.window.localStorage['token'];

  final response = await http.post(
    Uri.parse('$baseUrl/admin/sos'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'name_sos': name,
      'alamat_sos': alamat,
      'telepon': telepon,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return SOS.fromJson(json['data']);
  } 
  debugPrint('Create SOS error: ${response.body}');
  return null;
}

Future<bool> updateSOS({
  required int id,
  required String name,
  required String alamat,
  required String telepon,
}) async {
  final token = html.window.localStorage['token'];

  final response = await http.put(
    Uri.parse('$baseUrl/admin/sos/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'name_sos': name,
      'alamat_sos': alamat,
      'telepon': telepon,
    }),
  );

  return response.statusCode == 200;
}

Future<void> deleteSOS(int id) async {
  final token = html.window.localStorage['token'];

  final response = await http.delete(
    Uri.parse('$baseUrl/admin/sos/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus SOS');
  }
}

final List<SOS> sos = [
  SOS(
    id_sos: 1,
    name: "Ubud Clinic",
    address: "Jl. Raya Ubud No.36, Gianyar, Bali",
    phone: "+62361978555",
  ),
  SOS(
    id_sos: 2,
    name: "Puskesmas Tegallalang I",
    address: "Jl. Raya Tegallalang, Gianyar, Bali",
    phone: "+62 361 975 456",
  ),
  SOS(
    id_sos: 3,
    name: "RS Ari Canti",
    address: "Jl. Raya Mas, Ubud, Gianyar",
    phone: "+62 361 975 833",
  ),
  SOS(
    id_sos: 4,
    name: "Puskesmas Ubud I",
    address: "Jl. Raya Andong, Peliatan, Gianyar",
    phone: "+62 361 975 123",
  ),
  SOS(
    id_sos: 5,
    name: "Ubud Medical Centre",
    address: "Jl. Sukma Kesuma, Peliatan, Ubud",
    phone: "+62 361 974 911",
  ),
];