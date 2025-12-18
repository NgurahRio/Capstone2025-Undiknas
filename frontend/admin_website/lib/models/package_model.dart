import 'dart:convert';
import 'dart:typed_data';
import 'package:admin_website/models/destination_model.dart';
import 'package:admin_website/models/subPackage_model.dart';
import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;

class PackageFormRow {
  int subPackageId;
  int price;
  String includeName;
  Uint8List? imageBytes;
  String? imagePreview;

  PackageFormRow({
    required this.subPackageId,
    required this.price,
    required this.includeName,
    this.imageBytes,
    this.imagePreview,
  });
}

class SubPackageInput {
  final int subPackageId;
  final int price;
  final String includeName;
  final Uint8List imageBytes;
  final String imageName;

  SubPackageInput({
    required this.subPackageId,
    required this.price,
    required this.includeName,
    required this.imageBytes,
    required this.imageName,
  });
}

List<PackageFormRow> initPackageFormRows(Package package) {
  final List<PackageFormRow> rows = [];

  package.subPackages.forEach((subPackage, data) {
    final int price = data['price'];
    final List includes = data['include'];

    for (final inc in includes) {
      rows.add(
        PackageFormRow(
          subPackageId: subPackage.id_subPackage,
          price: price,
          includeName: inc['name'],
          imagePreview: inc['image'],
        ),
      );
    }
  });

  return rows;
}

class Package {
  final int id_package;
  final Destination destinationId;
  final Map<SubPackage, Map<String, dynamic>> subPackages;

  Package({
    required this.id_package,
    required this.destinationId,
    required this.subPackages,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    final destination = Destination.fromJson(json['destination']);

    final List subpackageList = json['subpackages'];
    final Map<String, dynamic> subpackageData = json['subpackage_data'];

    final Map<int, SubPackage> subMap = {
      for (var sp in subpackageList)
        sp['id_subpackage']: SubPackage.fromJson(sp)
    };

    final Map<SubPackage, Map<String, dynamic>> result = {};

    subpackageData.forEach((key, value) {
      final int subId = int.parse(key);

      final subPackage = subMap[subId];
      if (subPackage != null) {
        result[subPackage] = {
          "price": value['price'],
          "include": value['include'],
        };
      }
    });

    return Package(
      id_package: json['id_packages'],
      destinationId: destination,
      subPackages: result,
    );
  }
}

Future<List<Package>> getPackages() async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/packages'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal ambil package');
  }

  final jsonData = jsonDecode(response.body);
  final List list = jsonData['data'];

  return list.map((e) => Package.fromJson(e)).toList();
}

Future<Package> getPackageByDestination(int destinationId) async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/packages/$destinationId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal ambil package berdasarkan destination');
  }

  final jsonData = jsonDecode(response.body);
  final data = jsonData['data'];

  return Package.fromJson(data);
}

Future<void> createPackages({
  required int destinationId,
  required List<SubPackageInput> subPackages,
}) async {
  final token = html.window.localStorage['token'];

  final uri = Uri.parse('$baseUrl/admin/packages');
  final request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer $token';

  request.fields['destinationId'] = destinationId.toString();
  request.fields['subPackageId'] = subPackages.map((e) => e.subPackageId).join(',');
  request.fields['price'] = subPackages.map((e) => e.price).join(',');
  request.fields['includeName'] = subPackages.map((e) => e.includeName).join(',');

  for (int i = 0; i < subPackages.length; i++) {
    final sp = subPackages[i];

    if (sp.imageBytes.isEmpty) {
      throw Exception('Image kosong di index $i');
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        sp.imageBytes,
        filename: sp.imageName,
      ),
    );
  }
  final response = await request.send();
  final body = await response.stream.bytesToString();

  if (response.statusCode != 200) {
    throw Exception(body);
  }
}

Future<void> updatePackages({
  required int destinationId,
  required List<SubPackageInput> subPackages,
}) async {
  final token = html.window.localStorage['token'];

  final uri = Uri.parse(
    '$baseUrl/admin/packages/$destinationId',
  );

  final request = http.MultipartRequest('PUT', uri);
  request.headers['Authorization'] = 'Bearer $token';

  request.fields['subPackageId'] = subPackages.map((e) => e.subPackageId).join(',');
  request.fields['price'] = subPackages.map((e) => e.price).join(',');
  request.fields['includeName'] = subPackages.map((e) => e.includeName).join(',');

  for (int i = 0; i < subPackages.length; i++) {
    final sp = subPackages[i];
    if (sp.imageBytes.isEmpty) {
      throw Exception('Image kosong di index $i');
    }
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        sp.imageBytes,
        filename: sp.imageName,
      ),
    );
  }
  final response = await request.send();
  final body = await response.stream.bytesToString();

  if (response.statusCode != 200) {
    throw Exception(body);
  }
}

Future<void> deletePackage(int idPackage) async {
  final token = html.window.localStorage['token'];

  final response = await http.delete(
    Uri.parse('$baseUrl/admin/packages/$idPackage'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus package');
  }
}

// final packages = [
//   Package(
//     id_package: 1,
//     destinationId: destinations.firstWhere((d) => d.id_destination == 1),
//     subPackages: {
//       subPackages[0]: {
//         "price": 50000,
//         "include": [
//           {
//             "image": "assets/icons/entrance.png", 
//             "name": "Entrance Ticket"}
//         ],
//       },
//       subPackages[1]: {
//         "price": 75000,
//         "include": [
//           {
//             "image": "assets/icons/guide.png", 
//             "name": "Local Guide"},
//         ],
//       },
//     },
//   )
// ];
