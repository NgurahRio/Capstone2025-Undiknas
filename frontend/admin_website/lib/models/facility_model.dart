// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String detectExt(Uint8List bytes) {
  if (bytes.length >= 12) {
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }

    if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return 'jpg';
    }
    if (bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'webp';
    }
  }

  return 'jpg';
}


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

Future<Facility?> createFacility({
  required String nameFacility,
  required Uint8List iconBytes,
}) async {
  if (iconBytes.isEmpty) {
    throw Exception('Icon tidak boleh kosong');
  }

  final token = html.window.localStorage['token'];
  final uri = Uri.parse('$baseUrl/admin/facility');

  final request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer $token';
  request.fields['namefacility'] = nameFacility;

  final ext = detectExt(iconBytes);

  request.files.add(
    http.MultipartFile.fromBytes(
      'icon',
      iconBytes,
      filename: 'icon.$ext', // 🔥 fleksibel
    ),
  );

  final response = await request.send();
  final body = await response.stream.bytesToString();

  if (response.statusCode == 201 || response.statusCode == 200) {
    final json = jsonDecode(body);
    return Facility.fromJson(json['data']);
  }

  throw Exception('Gagal create facility: $body');
}

Future<bool> updateFacility({
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

  if (iconBytes != null && iconBytes.isNotEmpty) {
    final ext = detectExt(iconBytes);

    request.files.add(
      http.MultipartFile.fromBytes(
        'icon',
        iconBytes,
        filename: 'icon.$ext',
      ),
    );
  }

  final response = await request.send();
  return response.statusCode == 200;
}

Future<void> deleteFacility (int idFacility) async {
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