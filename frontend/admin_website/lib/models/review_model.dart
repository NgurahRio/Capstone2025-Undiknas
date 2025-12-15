import 'package:admin_website/models/destination_model.dart';
import 'package:admin_website/models/event_model.dart';
import 'package:admin_website/models/role_model.dart';
import 'package:admin_website/models/user_model.dart';
import 'dart:html' as html;
import 'package:admin_website/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      userId: json['user'] != null
          ? User.fromJson(json['user'])
          : User(
              id_user: 0,
              username: 'Unknown',
              email: '',
              roleId: Role(id_role: 0, role_name: 'unknown'),
            ),
      destinationId: json['destination'] != null
          ? Destination.fromJson(json['destination'])
          : null,
      eventId: json['event'] != null
          ? Event.fromJson(json['event'])
          : null,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

Future<List<Review>> getReviews() async {
  final token = html.window.localStorage['token'];

  final response = await http.get(
    Uri.parse('$baseUrl/admin/review'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal ambil review');
  }

  final jsonData = jsonDecode(response.body);
  final List list = jsonData['data'];

  return list.map((e) => Review.fromJson(e)).toList();
}

Future<void> deleteReview (int idReview) async {
  final token = html.window.localStorage['token'];

  final response = await http.delete(
    Uri.parse('$baseUrl/admin/review/$idReview'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus review');
  }
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