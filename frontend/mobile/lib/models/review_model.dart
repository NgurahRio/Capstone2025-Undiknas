import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/user_model.dart';


double averageRatingForDestination(int destinationId) {
  final relatedRatings = reviews.where(
    (rat) => rat.destinationId?.id_destination == destinationId).toList();

  if (relatedRatings.isEmpty) return 0;

  final total = relatedRatings.fold(0.0, (sum, rat) => sum + rat.rating);
  return total / relatedRatings.length;
}

double averageRatingForEvent(int eventId) {
  final relatedRatings =
      reviews.where((rat) => rat.eventId?.id_event == eventId).toList();

  if (relatedRatings.isEmpty) return 0;

  final total = relatedRatings.fold(0.0, (sum, rat) => sum + rat.rating);
  return total / relatedRatings.length;
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
}

List<Review> reviews = [
  Review(
    id_review: 1,
    userId: users.firstWhere((u) => u.id_user == 3),
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    rating: 4.8,
    comment: "Monyetnya lucu, tapi hati-hati dengan barang bawaan.",
    createdAt: DateTime(2025, 9, 20, 10, 30),
  ),
  Review(
    id_review: 2,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    rating: 3,
    comment: "Tempatnya bersih dan terawat, cocok untuk wisata keluarga.",
    createdAt: DateTime(2025, 9, 21, 12, 10),
  ),

  Review(
    id_review: 3,
    userId: users.firstWhere((u) => u.id_user == 3),
    destinationId: destinations.firstWhere((d) => d.id_destination == 2),
    rating: 3,
    comment: "Pemandangannya indah banget, tapi agak ramai siang hari.",
    createdAt: DateTime(2025, 9, 22, 14, 15),
  ),
  Review(
    id_review: 4,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 2),
    rating: 4.5,
    comment: "Tempat bagus buat jalan santai, cocok untuk healing.",
    createdAt: DateTime(2025, 9, 23, 11, 25),
  ),

  // Goa Gajah
  Review(
    id_review: 5,
    userId: users.firstWhere((u) => u.id_user == 3),
    destinationId: destinations.firstWhere((d) => d.id_destination == 3),
    rating: 4.7,
    comment: "Tempat suci dan bersejarah, suasananya mistis tapi indah.",
    createdAt: DateTime(2025, 9, 24, 10, 00),
  ),
  Review(
    id_review: 6,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 3),
    rating: 4.4,
    comment: "Area parkir luas dan banyak penjual oleh-oleh.",
    createdAt: DateTime(2025, 9, 24, 14, 50),
  ),

  // Campuhan Ridge Walk
  Review(
    id_review: 7,
    userId: users.firstWhere((u) => u.id_user == 3),
    destinationId: destinations.firstWhere((d) => d.id_destination == 4),
    rating: 4.6,
    comment: "Jalur trekking dengan pemandangan luar biasa.",
    createdAt: DateTime(2025, 9, 26, 9, 10),
  ),
  Review(
    id_review: 8,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 4),
    rating: 4.8,
    comment: "Tempat favorit buat olahraga pagi, sejuk dan tenang.",
    createdAt: DateTime(2025, 9, 26, 17, 45),
  ),

  // Pura Taman Saraswati
  Review(
    id_review: 9,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 5),
    rating: 4.7,
    comment: "Pura yang indah dan tenang, kolam teratainya keren.",
    createdAt: DateTime(2025, 9, 27, 15, 20),
  ),
  Review(
    id_review: 10,
    userId: users.firstWhere((u) => u.id_user == 3),
    destinationId: destinations.firstWhere((d) => d.id_destination == 5),
    rating: 4.5,
    comment: "Cocok buat foto-foto, suasananya adem.",
    createdAt: DateTime(2025, 9, 28, 10, 15),
  ),
];