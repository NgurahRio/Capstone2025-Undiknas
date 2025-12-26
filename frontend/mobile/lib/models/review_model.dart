import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/api.dart';
import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


double averageRatingForDestination(
  int destinationId,
  List<Review> reviews,
) {
  final related = reviews
      .where((r) => r.destinationId?.id_destination == destinationId)
      .toList();

  if (related.isEmpty) return 0;

  final total = related.fold<double>(0, (sum, r) => sum + r.rating);
  return total / related.length;
}

double averageRatingForEvent(
  int eventId,
  List<Review> reviews,
) {
  final related = reviews
      .where((r) => r.eventId?.id_event == eventId)
      .toList();

  if (related.isEmpty) return 0;

  final total = related.fold<double>(0, (sum, r) => sum + r.rating);
  return total / related.length;
}


class Review {
  final int id_review;
  final User userId;
  final Destination? destinationId;
  final Event? eventId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id_review,
    required this.userId,
    this.destinationId,
    this.eventId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id_review: json['id_review'],
      userId: User.fromJson(json['user']),
      destinationId: json['destination'] != null
          ? Destination.fromJson(json['destination'])
          : null,
      eventId: json['event'] != null
          ? Event.fromJson(json['event'])
          : null,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

Future<List<Review>> getReviews() async {
  final response = await http.get(
    Uri.parse('$baseUrl/review'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal mengambil review');
  }
  final decoded = jsonDecode(response.body);
  final List list = decoded['data'];
  return list.map((e) => Review.fromJson(e)).toList();
}

Future<Review> createReview({
  int? destinationId,
  int? eventId,
  required int rating,
  required String comment,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) throw Exception('SESSION_EXPIRED');

  final response = await http.post(
    Uri.parse('$baseUrl/user/review'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      if (destinationId != null) "destinationId": destinationId,
      if (eventId != null) "eventId": eventId,
      "rating": rating,
      "comment": comment,
    }),
  );

  if (response.statusCode == 201) {
    final decoded = jsonDecode(response.body);
    return Review.fromJson(decoded['data']);
  }

  throw Exception(response.body);
}


// List<Review> reviews = [
//   Review(
//     id_review: 1,
//     userId: users.firstWhere((u) => u.id_user == 3),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 1),
//     rating: 4.8,
//     comment: "Monyetnya lucu, tapi hati-hati dengan barang bawaan.",
//     createdAt: DateTime(2025, 9, 20, 10, 30),
//   ),
//   Review(
//     id_review: 2,
//     userId: users.firstWhere((u) => u.id_user == 2),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 1),
//     rating: 3,
//     comment: "Tempatnya bersih dan terawat, cocok untuk wisata keluarga.",
//     createdAt: DateTime(2025, 9, 21, 12, 10),
//   ),

//   Review(
//     id_review: 3,
//     userId: users.firstWhere((u) => u.id_user == 3),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 2),
//     rating: 3,
//     comment: "Pemandangannya indah banget, tapi agak ramai siang hari.",
//     createdAt: DateTime(2025, 9, 22, 14, 15),
//   ),
//   Review(
//     id_review: 4,
//     userId: users.firstWhere((u) => u.id_user == 2),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 2),
//     rating: 4.5,
//     comment: "Tempat bagus buat jalan santai, cocok untuk healing.",
//     createdAt: DateTime(2025, 9, 23, 11, 25),
//   ),

//   // Goa Gajah
//   Review(
//     id_review: 5,
//     userId: users.firstWhere((u) => u.id_user == 3),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 3),
//     rating: 4.7,
//     comment: "Tempat suci dan bersejarah, suasananya mistis tapi indah.",
//     createdAt: DateTime(2025, 9, 24, 10, 00),
//   ),
//   Review(
//     id_review: 6,
//     userId: users.firstWhere((u) => u.id_user == 2),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 3),
//     rating: 4.4,
//     comment: "Area parkir luas dan banyak penjual oleh-oleh.",
//     createdAt: DateTime(2025, 9, 24, 14, 50),
//   ),

//   // Campuhan Ridge Walk
//   Review(
//     id_review: 7,
//     userId: users.firstWhere((u) => u.id_user == 3),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 4),
//     rating: 4.6,
//     comment: "Jalur trekking dengan pemandangan luar biasa.",
//     createdAt: DateTime(2025, 9, 26, 9, 10),
//   ),
//   Review(
//     id_review: 8,
//     userId: users.firstWhere((u) => u.id_user == 2),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 4),
//     rating: 4.8,
//     comment: "Tempat favorit buat olahraga pagi, sejuk dan tenang.",
//     createdAt: DateTime(2025, 9, 26, 17, 45),
//   ),

//   // Pura Taman Saraswati
//   Review(
//     id_review: 9,
//     userId: users.firstWhere((u) => u.id_user == 2),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 5),
//     rating: 4.7,
//     comment: "Pura yang indah dan tenang, kolam teratainya keren.",
//     createdAt: DateTime(2025, 9, 27, 15, 20),
//   ),
//   Review(
//     id_review: 10,
//     userId: users.firstWhere((u) => u.id_user == 3),
//     destinationId: destinations.firstWhere((d) => d.id_destination == 5),
//     rating: 4.5,
//     comment: "Cocok buat foto-foto, suasananya adem.",
//     createdAt: DateTime(2025, 9, 28, 10, 15),
//   ),
// ];