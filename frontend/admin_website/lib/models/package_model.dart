import 'dart:convert';
import 'dart:typed_data';
import 'package:admin_website/models/destination_model.dart';
import 'package:admin_website/models/subPackage_model.dart';
import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;


class Package {
  final int id_package;
  final Destination destinationId;
  final Map<SubPackage, Map<String, dynamic>> subPackages;

  Package({
    required this.id_package,
    required this.destinationId,
    required this.subPackages,
  });
}

// Future<void> createPackage(Package pkg) async {
//   final token = html.window.localStorage['token'];

//   final uri = Uri.parse('$baseUrl/admin/packages');
//   final request = http.MultipartRequest('POST', uri);

//   request.headers['Authorization'] = 'Bearer $token';

//   request.fields['destinationId'] =
//       pkg.destinationId.id_destination.toString();
//   for (final entry in pkg.subPackages.entries) {
//     final SubPackage sp = entry.key;
//     final Map<String, dynamic> detail = entry.value;

//     final int price = detail['price'];
//     final List<dynamic> includes = detail['include'] ?? [];

//     if (includes.isEmpty) {
//       throw Exception("Include image wajib untuk ${sp.name}");
//     }
//     final include = includes.first;

//     request.fields['subPackageId'].add(sp.id_subPackage.toString());
//     request.fields['price'].add(price.toString());

//     if (include['name'] != null && include['name'].toString().isNotEmpty) {
//       request.fields['includeName'].add(include['name']);
//     }

//     final img = include['image'];

//     Uint8List bytes;
//     if (img is Uint8List) {
//       bytes = img;
//     } else if (img is String) {
//       // base64
//       bytes = base64Decode(img);
//     } else {
//       throw Exception("Format image tidak valid");
//     }

//     request.files.add(
//       http.MultipartFile.fromBytes(
//         'image',
//         bytes,
//         filename: 'subpackage_${sp.id_subPackage}.jpg',
//       ),
//     );
//   }
//   final streamed = await request.send();
//   final response = await http.Response.fromStream(streamed);

//   if (response.statusCode != 200) {
//     throw Exception(response.body);
//   }
// }

final packages = [
  Package(
    id_package: 1,
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    subPackages: {
      subPackages[0]: {
        "price": 50000,
        "include": [
          {
            "image": "assets/icons/entrance.png", 
            "name": "Entrance Ticket"}
        ],
      },
      subPackages[1]: {
        "price": 75000,
        "include": [
          {
            "image": "assets/icons/guide.png", 
            "name": "Local Guide"},
        ],
      },
    },
  )
];
