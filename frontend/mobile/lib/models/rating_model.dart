import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/user_model.dart';


double averageRatingForDestination(int destinationId) {
  final relatedRatings = ratings.where(
    (rat) => rat.destinationId?.id_destination == destinationId).toList();

  if (relatedRatings.isEmpty) return 0;

  final total = relatedRatings.fold(0.0, (sum, rat) => sum + rat.rating);
  return total / relatedRatings.length;
}

double averageRatingForEvent(int eventId) {
  final relatedRatings =
      ratings.where((rat) => rat.eventId?.id_event == eventId).toList();

  if (relatedRatings.isEmpty) return 0;

  final total = relatedRatings.fold(0.0, (sum, rat) => sum + rat.rating);
  return total / relatedRatings.length;
}

class Rating {
  final int id_rating;
  final User userId;
  final Destination? destinationId;
  final Event? eventId;
  final double rating;
  final String review;
  final DateTime createdAt;

  Rating({
    required this.id_rating,
    required this.userId,
    this.destinationId,
    this.eventId,
    required this.rating,
    required this.review,
    required this.createdAt,
  });
}

List<Rating> ratings = [
  // Monkey Forest Ubud
  Rating(
    id_rating: 1,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    rating: 4.8,
    review: "Monyetnya lucu, tapi hati-hati dengan barang bawaan.",
    createdAt: DateTime(2025, 9, 20, 10, 30),
  ),
  Rating(
    id_rating: 2,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    rating: 3,
    review: "Tempatnya bersih dan terawat, cocok untuk wisata keluarga.",
    createdAt: DateTime(2025, 9, 21, 12, 10),
  ),
  Rating(
    id_rating: 3,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    rating: 4.9,
    review: "Suasana alamnya menenangkan, banyak spot foto bagus.",
    createdAt: DateTime(2025, 9, 22, 9, 45),
  ),

  Rating(
    id_rating: 4,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 2),
    rating: 3,
    review: "Pemandangannya indah banget, tapi agak ramai siang hari.",
    createdAt: DateTime(2025, 9, 22, 14, 15),
  ),
  Rating(
    id_rating: 5,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 2),
    rating: 4.5,
    review: "Tempat bagus buat jalan santai, cocok untuk healing.",
    createdAt: DateTime(2025, 9, 23, 11, 25),
  ),
  Rating(
    id_rating: 6,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 2),
    rating: 4.2,
    review: "Suasana pedesaan Bali yang asli banget.",
    createdAt: DateTime(2025, 9, 23, 16, 40),
  ),

  // Goa Gajah
  Rating(
    id_rating: 7,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 3),
    rating: 4.7,
    review: "Tempat suci dan bersejarah, suasananya mistis tapi indah.",
    createdAt: DateTime(2025, 9, 24, 10, 00),
  ),
  Rating(
    id_rating: 8,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 3),
    rating: 4.4,
    review: "Area parkir luas dan banyak penjual oleh-oleh.",
    createdAt: DateTime(2025, 9, 24, 14, 50),
  ),
  Rating(
    id_rating: 9,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 3),
    rating: 4.9,
    review: "Gua kuno yang sangat menarik, wajib dikunjungi!",
    createdAt: DateTime(2025, 9, 25, 8, 30),
  ),

  // Campuhan Ridge Walk
  Rating(
    id_rating: 10,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 4),
    rating: 4.6,
    review: "Jalur trekking dengan pemandangan luar biasa.",
    createdAt: DateTime(2025, 9, 26, 9, 10),
  ),
  Rating(
    id_rating: 11,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 4),
    rating: 4.8,
    review: "Tempat favorit buat olahraga pagi, sejuk dan tenang.",
    createdAt: DateTime(2025, 9, 26, 17, 45),
  ),
  Rating(
    id_rating: 12,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 4),
    rating: 4.4,
    review: "Datang pagi biar gak panas, recommended banget.",
    createdAt: DateTime(2025, 9, 27, 6, 55),
  ),

  // Pura Taman Saraswati
  Rating(
    id_rating: 13,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 5),
    rating: 4.7,
    review: "Pura yang indah dan tenang, kolam teratainya keren.",
    createdAt: DateTime(2025, 9, 27, 15, 20),
  ),
  Rating(
    id_rating: 14,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 5),
    rating: 4.5,
    review: "Cocok buat foto-foto, suasananya adem.",
    createdAt: DateTime(2025, 9, 28, 10, 15),
  ),
  Rating(
    id_rating: 15,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 5),
    rating: 3,
    review: "Sangat direkomendasikan untuk wisata budaya.",
    createdAt: DateTime(2025, 9, 28, 13, 40),
  ),

  // Ubud Palace
  Rating(
    id_rating: 16,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 6),
    rating: 4.3,
    review: "Bangunannya megah, bisa lihat tari tradisional juga.",
    createdAt: DateTime(2025, 9, 29, 11, 25),
  ),
  Rating(
    id_rating: 17,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 6),
    rating: 3,
    review: "Tempat bersejarah di tengah kota Ubud, keren banget.",
    createdAt: DateTime(2025, 9, 29, 15, 00),
  ),
  Rating(
    id_rating: 18,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 6),
    rating: 4.4,
    review: "Bagus untuk belajar budaya Bali, aksesnya mudah.",
    createdAt: DateTime(2025, 9, 29, 18, 20),
  ),

  // Blanco Renaissance Museum
  Rating(
    id_rating: 19,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 7),
    rating: 4.9,
    review: "Karya seni luar biasa, tempatnya megah banget.",
    createdAt: DateTime(2025, 9, 30, 11, 00),
  ),
  Rating(
    id_rating: 20,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 7),
    rating: 4.7,
    review: "Museum yang menarik, stafnya ramah dan informatif.",
    createdAt: DateTime(2025, 9, 30, 14, 15),
  ),
  Rating(
    id_rating: 21,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 7),
    rating: 3,
    review: "Koleksinya keren, suasananya elegan.",
    createdAt: DateTime(2025, 9, 30, 17, 10),
  ),

  // Museum Puri Lukisan
  Rating(
    id_rating: 22,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 8),
    rating: 4.5,
    review: "Karya seni klasik Bali yang indah banget.",
    createdAt: DateTime(2025, 10, 1, 9, 25),
  ),
  Rating(
    id_rating: 23,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 8),
    rating: 4.3,
    review: "Museum tenang dan bersih, cocok untuk belajar budaya.",
    createdAt: DateTime(2025, 10, 1, 12, 00),
  ),
  Rating(
    id_rating: 24,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 8),
    rating: 3,
    review: "Koleksi lukisan banyak dan bersejarah.",
    createdAt: DateTime(2025, 10, 1, 16, 30),
  ),

  // ARMA Museum
  Rating(
    id_rating: 25,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 9),
    rating: 4.7,
    review: "Kombinasi museum dan taman yang luar biasa.",
    createdAt: DateTime(2025, 10, 2, 10, 10),
  ),
  Rating(
    id_rating: 26,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 9),
    rating: 4.8,
    review: "Seni modern dan tradisional berpadu harmonis.",
    createdAt: DateTime(2025, 10, 2, 14, 45),
  ),
  Rating(
    id_rating: 27,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 9),
    rating: 3,
    review: "Tempat tenang dan edukatif, sangat direkomendasikan.",
    createdAt: DateTime(2025, 10, 2, 18, 05),
  ),

  // Ubud Art Market
  Rating(
    id_rating: 28,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 10),
    rating: 3,
    review: "Banyak pilihan oleh-oleh, harga bisa ditawar.",
    createdAt: DateTime(2025, 10, 3, 11, 30),
  ),
  Rating(
    id_rating: 29,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 10),
    rating: 4.1,
    review: "Tempatnya ramai, tapi produk lokalnya keren-keren.",
    createdAt: DateTime(2025, 10, 3, 15, 20),
  ),
  Rating(
    id_rating: 30,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 10),
    rating: 3,
    review: "Suka suasananya, banyak karya seni unik.",
    createdAt: DateTime(2025, 10, 3, 18, 00),
  ),

  // Rating(
  //   id_rating: 31,
  //   userId: users.firstWhere((u) => u.id_user == 1),
  //   eventId: events.firstWhere((e) => e.id_event == 1),
  //   rating: 4.7,
  //   review: "Festivalnya seru banget! Banyak makanan lokal enak dan suasana meriah.",
  //   createdAt: DateTime(2025, 9, 27, 14, 20),
  // ),
  // Rating(
  //   id_rating: 32,
  //   userId: users.firstWhere((u) => u.id_user == 2),
  //   eventId: events.firstWhere((e) => e.id_event == 1),
  //   rating: 4.5,
  //   review: "Cocok untuk pecinta kuliner, tapi agak ramai di sore hari.",
  //   createdAt: DateTime(2025, 9, 27, 18, 00),
  // ),
  // Rating(
  //   id_rating: 33,
  //   userId: users.firstWhere((u) => u.id_user == 1),
  //   eventId: events.firstWhere((e) => e.id_event == 2),
  //   rating: 4.9,
  //   review: "Festival seni terbaik di Bali! Tari-tariannya keren banget.",
  //   createdAt: DateTime(2025, 9, 30, 19, 10),
  // ),
  // Rating(
  //   id_rating: 34,
  //   userId: users.firstWhere((u) => u.id_user == 2),
  //   eventId: events.firstWhere((e) => e.id_event == 2),
  //   rating: 4.6,
  //   review: "Wajib dikunjungi tiap tahun, pameran kerajinannya luar biasa.",
  //   createdAt: DateTime(2025, 9, 30, 20, 45),
  // ),
  // Rating(
  //   id_rating: 35,
  //   userId: users.firstWhere((u) => u.id_user == 1),
  //   eventId: events.firstWhere((e) => e.id_event == 3),
  //   rating: 4.8,
  //   review: "Banyak penulis keren hadir, suasananya intelektual tapi santai.",
  //   createdAt: DateTime(2025, 10, 5, 13, 15),
  // ),
  // Rating(
  //   id_rating: 36,
  //   userId: users.firstWhere((u) => u.id_user == 2),
  //   eventId: events.firstWhere((e) => e.id_event == 3),
  //   rating: 4.7,
  //   review: "Diskusinya inspiratif, tempatnya juga nyaman di Ubud.",
  //   createdAt: DateTime(2025, 10, 5, 16, 00),
  // ),
  // Rating(
  //   id_rating: 37,
  //   userId: users.firstWhere((u) => u.id_user == 1),
  //   eventId: events.firstWhere((e) => e.id_event == 4),
  //   rating: 5.0,
  //   review: "Hari tenang yang penuh makna. Pengalaman spiritual yang unik!",
  //   createdAt: DateTime(2025, 10, 14, 9, 00),
  // ),
  // Rating(
  //   id_rating: 38,
  //   userId: users.firstWhere((u) => u.id_user == 2),
  //   eventId: events.firstWhere((e) => e.id_event == 5),
  //   rating: 4.4,
  //   review: "Fashion show-nya keren, desainernya top semua!",
  //   createdAt: DateTime(2025, 10, 8, 20, 30),
  // ),
  // Rating(
  //   id_rating: 39,
  //   userId: users.firstWhere((u) => u.id_user == 1),
  //   eventId: events.firstWhere((e) => e.id_event == 5),
  //   rating: 4.2,
  //   review: "Event besar dan megah, tapi parkir agak susah.",
  //   createdAt: DateTime(2025, 10, 8, 22, 10),
  // ),
  // Rating(
  //   id_rating: 40,
  //   userId: users.firstWhere((u) => u.id_user == 2),
  //   eventId: events.firstWhere((e) => e.id_event == 6),
  //   rating: 4.9,
  //   review: "Upacara adat yang sakral dan luar biasa, budaya Toraja sangat menarik!",
  //   createdAt: DateTime(2025, 11, 5, 15, 40),
  // ),
  // Rating(
  //   id_rating: 41,
  //   userId: users.firstWhere((u) => u.id_user == 1),
  //   eventId: events.firstWhere((e) => e.id_event == 6),
  //   rating: 4.8,
  //   review: "Unik sekali, bisa belajar banyak soal tradisi Toraja.",
  //   createdAt: DateTime(2025, 11, 5, 18, 00),
  // ),
];