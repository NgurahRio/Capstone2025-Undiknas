import 'dart:typed_data';

import 'package:admin_website/models/facility_model.dart';
import 'package:admin_website/models/sos_model.dart';
import 'package:admin_website/models/subCategory_model.dart';
import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<String> _parseList(dynamic value) {
  if (value == null) return [];

  if (value is List) {
    return value.map((e) => e.toString().trim()).toList();
  }

  if (value is String) {
    return value
        .split(RegExp(r'[,\n]')) // support koma & newline
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  return [];
}

class Destination {
  final int id_destination;
  final String name;
  final List<String> imageUrl;
  final String location;
  final String description;
  final String operational;
  final String maps;
  final double latitude;
  final double longitude;
  final List<SubCategory> subCategoryId;
  final List<String>? dos;
  final List<String>? donts;
  final List<String>? safetyGuidelines;
  final List<Facility>? facilities;
  final SOS? sos;

  Destination({
    required this.id_destination,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.description,
    required this.operational,
    required this.maps,
    required this.latitude,
    required this.longitude,
    this.subCategoryId = const [],
    this.dos = const [],
    this.donts = const [],
    this.safetyGuidelines = const [],
    this.facilities = const [],
    this.sos,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id_destination: json['id_destination'],
      name: json['namedestination'] ?? '',
      imageUrl: json['images'] is List
          ? List<String>.from(json['images'])
          : [],
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      operational: json['operational'] ?? '',
      maps: json['maps'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      subCategoryId: json['subcategory'] is List
        ? (json['subcategory'] as List)
            .map((x) => SubCategory.fromJson(x))
            .toList()
        : [],
      dos: _parseList(json['do']),
      donts: _parseList(json['dont']),
      safetyGuidelines: _parseList(json['safety']),
      facilities: json['facilities'] is List
          ? (json['facilities'] as List)
              .map((x) => Facility.fromJson(x))
              .toList()
          : [],
      sos: json['sos'] != null
          ? SOS.fromJson(json['sos'])
          : null,
    );
  }
}

Future<List<Destination>> getDestinations() async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/destination'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode != 200) {
    throw Exception('Gagal mengambil destinasi');
  }
  final decoded = jsonDecode(response.body);
  final List list = decoded['data'];
  return list.map((e) => Destination.fromJson(e)).toList();
}

Future<Destination> getDestinationById(int id) async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/destination/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal mengambil detail destinasi');
  }

  final decoded = jsonDecode(response.body);
  final Map<String, dynamic> data = decoded['data'];
  return Destination.fromJson(data);
}

Future<Destination> createDestination({
  required String name,
  required String location,
  required String description,
  required List<int> subcategoryIds,
  required List<int> facilityIds,
  required List<Uint8List> images,
  required String operational,
  required String maps,
  required double latitude,
  required double longitude,
  required int sosId,
  String doText = "",
  String dontText = "",
  String safetyText = "",
}) async {
  final token = html.window.localStorage['token'];

  final uri = Uri.parse('$baseUrl/admin/destination');
  final request = http.MultipartRequest('POST', uri);

  request.headers['Authorization'] = 'Bearer $token';

  request.fields.addAll({
    'namedestination': name,
    'location': location,
    'description': description,
    'subcategoryId': subcategoryIds.join(','),
    'facilityId': facilityIds.join(','),
    'do': doText,
    'dont': dontText,
    'safety': safetyText,
    'maps': maps,
    'sosId': sosId.toString(),
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'operational': operational,
  });

  for (int i = 0; i < images.length; i++) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        images[i],
        filename: 'destination_$i.jpg',
      ),
    );
  }

  final streamed = await request.send();
  final response = await http.Response.fromStream(streamed);

  if (response.statusCode != 201) {
    throw Exception(response.body);
  }

  final json = jsonDecode(response.body);
  return Destination.fromJson(json['data']['destination']);
}

Future<Destination> updateDestination({
  required int id,
  required String name,
  required String location,
  required String description,
  required List<int> subcategoryIds,
  required List<int> facilityIds,
  required String operational,
  required String maps,
  required double latitude,
  required double longitude,
  required int sosId,
  required String doText,
  required String dontText,
  required String safetyText,
  Map<int, Uint8List>? updatedImages,
}) async {
  final token = html.window.localStorage['token'];
  final uri = Uri.parse('$baseUrl/admin/destination/$id');

  final request = http.MultipartRequest('PUT', uri);
  request.headers['Authorization'] = 'Bearer $token';

  request.fields.addAll({
    'namedestination': name,
    'location': location,
    'description': description,
    'subcategoryId': subcategoryIds.join(','),
    'facilityId': facilityIds.join(','),
    'do': doText,
    'dont': dontText,
    'safety': safetyText,
    'maps': maps,
    'operational': operational,
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'sosId': sosId.toString(),
  });

  if (updatedImages != null) {
    for (final entry in updatedImages.entries) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image[${entry.key}]',
          entry.value,
          filename: 'destination_${entry.key}.jpg',
        ),
      );
    }
  }

  final streamed = await request.send();
  final response = await http.Response.fromStream(streamed);

  if (response.statusCode != 200) {
    throw Exception(response.body);
  }

  final refreshed = await getDestinationById(id);
  return refreshed;
}

Future<void> deleteDestination (int idDestination) async {
  final token = html.window.localStorage['token'];

  final response = await http.delete(
    Uri.parse('$baseUrl/admin/destination/$idDestination'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus destination');
  }
}


List<SubCategory> getSubCategory(List<int> idSubc) {
  return subCategories.where((subc) => idSubc.contains(subc.id_subCategory)).toList();
}

List<Facility> getFacility(List<int> idF) {
  return facilities.where((f) => idF.contains(f.id_facility)).toList();
}

final List<Destination> destinations = [
  Destination(
    id_destination: 1,
    name: "Monkey Forest Ubud",
    imageUrl: [
      "https://picsum.photos/200/300?1",
      "https://picsum.photos/200/300?2",
    ],
    location: "Jl. Monkey Forest, Ubud, Gianyar, Bali",
    description:
        "Hutan yang menjadi habitat ratusan monyet ekor panjang di Ubud.",
    operational: "08:30 - 18:00",
    maps: "https://maps.app.goo.gl/4wwVNbjCXebKRAgK9ghvhgv",
    latitude: -8.519157,
    longitude: 115.263158,
    subCategoryId: getSubCategory([1, 3, 5]),
    dos: [
      "Ikuti arahan petugas",
      "Jaga barang bawaan",
      "Bawa botol minum sendiri",
    ],
    donts: [
      "Jangan beri makan monyet sembarangan",
      "Jangan menyentuh bayi monyet",
      "Jangan membawa makanan terbuka",
    ],
    safetyGuidelines: [
      "Jangan menatap monyet langsung ke mata",
      "Amankan barang berharga di tas tertutup",
      "Hindari kontak fisik dengan hewan liar",
    ],
    facilities: getFacility([1, 2, 3, 4, 5 ,6]),
    sos: sos.where((s) => s.id_sos == 1).first,
  ),
  Destination(
    id_destination: 2,
    name: "Tegallalang Rice Terrace",
    imageUrl: [
      "https://picsum.photos/200/300?3",
      "https://picsum.photos/200/300?4",
    ],
    location: "Tegallalang, Ubud, Gianyar, Bali",
    description: "Sawah terasering ikonik dengan pemandangan hijau nan asri.",
    operational: "07:00 - 18:00",
    maps: "https://goo.gl/maps/tegallalang",
    latitude: -8.441767,
    longitude: 115.279503,
    subCategoryId: getSubCategory([2]),
    dos: [
      "Gunakan alas kaki yang nyaman",
      "Hargai petani lokal",
    ],
    donts: [
      "Jangan menginjak tanaman padi",
      "Jangan buang sampah sembarangan",
    ],
    safetyGuidelines: [
      "Perhatikan langkah saat melewati jalur sempit",
      "Hindari berjalan saat hujan karena licin",
      "Gunakan topi dan tabir surya di siang hari",
    ],
    facilities: getFacility([1, 2, 3, 4, 5 ,6]),
    sos: sos.where((s) => s.id_sos == 2).first,
  ),
  Destination(
    id_destination: 3,
    name: "Goa Gajah",
    imageUrl: [
      "https://picsum.photos/200/300?5",
      "https://picsum.photos/200/300?6",
    ],
    location: "Bedulu, Ubud, Gianyar, Bali",
    description: "Situs arkeologi kuno dengan gua bersejarah dan patung suci.",
    operational: "08:00 - 17:00",
    maps: "https://goo.gl/maps/goagajah",
    latitude: -8.519221,
    longitude: 115.287021,
    subCategoryId: getSubCategory([3, 2]),
    dos: [
      "Kenakan pakaian sopan atau sarung",
      "Hormati area pura",
    ],
    donts: [
      "Jangan menyentuh patung suci",
      "Jangan berbicara terlalu keras",
    ],
    safetyGuidelines: [
      "Berhati-hati di area batu licin dan tangga sempit",
      "Gunakan alas kaki yang tidak mudah tergelincir",
      "Ikuti jalur wisata yang telah ditentukan",
    ],
    facilities: getFacility([1, 2, 3, 4, 5 ,6]),
    sos: sos.where((s) => s.id_sos == 3).first,
  ),
  Destination(
    id_destination: 4,
    name: "Campuhan Ridge Walk",
    imageUrl: [
      "https://picsum.photos/200/300?7",
      "https://picsum.photos/200/300?8",
    ],
    location: "Jl. Bangkiang Sidem, Ubud",
    description:
        "Jalur trekking populer dengan pemandangan bukit dan lembah hijau.",
    operational: "24 Jam",
    maps: "https://goo.gl/maps/campuhan",
    latitude: -8.506987,
    longitude: 115.257794,
    subCategoryId: getSubCategory([4]),
    dos: [
      "Datang pagi atau sore untuk cuaca sejuk",
      "Gunakan sepatu yang nyaman",
    ],
    donts: [
      "Jangan merusak tanaman di sekitar jalur",
      "Jangan membuang sampah",
    ],
    safetyGuidelines: [
      "Bawa air minum dan topi untuk perlindungan dari panas",
      "Waspadai jalur licin setelah hujan",
      "Berjalan di sisi kiri jalur untuk menghindari tabrakan dengan pengunjung lain",
    ],
    facilities: getFacility([1, 2, 3, 4, 5 ,6]),
    sos: sos.where((s) => s.id_sos == 4).first,
  ),
  Destination(
    id_destination: 5,
    name: "Pura Taman Saraswati",
    imageUrl: [
      "https://picsum.photos/200/300?9",
      "https://picsum.photos/200/300?10",
    ],
    location: "Jl. Kajeng, Ubud",
    description:
        "Pura indah dengan kolam bunga teratai, dedikasi untuk Dewi Saraswati.",
    operational: "08:00 - 18:00",
    maps: "https://goo.gl/maps/saraswati",
    latitude: -8.507604,
    longitude: 115.263289,
    subCategoryId: getSubCategory([5, 1]),
    dos: [
      "Gunakan pakaian sopan",
      "Hargai upacara keagamaan jika ada",
    ],
    donts: [
      "Jangan duduk di area persembahyangan",
    ],
    safetyGuidelines: [
      "Jaga jarak dari area persembahyangan",
      "Berhati-hati di sekitar kolam bunga agar tidak terpeleset",
      "Ikuti petunjuk petugas pura",
    ],
    facilities: getFacility([1, 2, 3, 4, 5 ,6]),
    sos: sos.where((s) => s.id_sos == 5).first,
  ),
];