// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Facility {
  final int id_facility;
  final String icon;
  final String name;

  Facility({
    required this.id_facility,
    required this.icon, 
    required this.name,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id_facility: json['id_facility'],
      name: json['namefacility'],
      icon: json['icon'] ?? '',
    );
  }
}

Future<List<Facility>> getFacilities() async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/facility'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal ambil fasilitas');
  }

  final jsonData = jsonDecode(response.body);
  final List list = jsonData['data'];

  return list.map((e) => Facility.fromJson(e)).toList();
}

Future<void> createFacility({
  required String nameFacility,
  required Uint8List iconBytes,
}) async {
  final token = html.window.localStorage['token'];

  final uri = Uri.parse('$baseUrl/admin/facility');

  final request = http.MultipartRequest('POST', uri);

  request.headers['Authorization'] = 'Bearer $token';

  request.fields['namefacility'] = nameFacility;

  request.files.add(
    http.MultipartFile.fromBytes(
      'icon',
      iconBytes,
      filename: 'icon.png',
    ),
  );

  final streamedResponse = await request.send();

  if (streamedResponse.statusCode != 201) {
    final body = await streamedResponse.stream.bytesToString();
    throw Exception('Gagal create facility: $body');
  }
}

Future<void> updateFacility({
  required int idFacility,
  String? nameFacility,
  Uint8List? iconBytes,
}) async {
  final token = html.window.localStorage['token'];

  final uri = Uri.parse('$baseUrl/admin/facility/$idFacility');

  final request = http.MultipartRequest('PUT', uri);

  request.headers['Authorization'] = 'Bearer $token';

  if (nameFacility != null && nameFacility.isNotEmpty) {
    request.fields['namefacility'] = nameFacility;
  }

  if (iconBytes != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'icon',
        iconBytes,
        filename: 'icon.png',
      ),
    );
  }

  final response = await request.send();

  if (response.statusCode != 200) {
    final body = await response.stream.bytesToString();
    throw Exception('Gagal update facility: $body');
  }
}

Future<void> deleteFacility(int idFacility) async {
  final token = html.window.localStorage['token'];

  final response = await http.delete(
    Uri.parse('$baseUrl/admin/facility/$idFacility'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus facility');
  }
}

final List<Facility> facilities = [
  Facility(
    id_facility: 1,
    icon: "assets/icons/parking.png", 
    name: "Parking"
  ),
  Facility(
    id_facility: 2,
    icon: "assets/icons/toilet.png", 
    name: "Toilet"
  ),
  Facility(
    id_facility: 3,
    icon: "assets/icons/guide.png", 
    name: "Local Guide"
  ),
  Facility(
    id_facility: 4,
    icon: "assets/icons/photo.png", 
    name: "Photo Area"
  ),
  Facility(
    id_facility: 5,
    icon: "assets/icons/shop.png", 
    name: "Souvenir Shop"
  ),
  Facility(
    id_facility: 6,
    icon: "assets/icons/wheelchair.png", 
    name: "Wheelchair Access"
  ),
];