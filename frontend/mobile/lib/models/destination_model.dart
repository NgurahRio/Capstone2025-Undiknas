import 'package:mobile/models/subCategory_model.dart';

class Facility {
  final String icon;
  final String name;

  Facility({required this.icon, required this.name});
}

class SosNearby {
  final String name;
  final String address;
  final String phone;

  SosNearby({
    required this.name,
    required this.address,
    required this.phone,
  });
}

class Destination {
  final int id_destination;
  final String name;
  final List<String> imageUrl;
  final String location;
  final String description;
  final String operation;
  final String maps;
  final double latitude;
  final double longitude;
  final SubCategory subCategoryId;
  final List<String>? dos;
  final List<String>? donts;
  final List<String>? safetyGuidelines;
  final List<Facility>? facilities;
  final List<SosNearby>? sosNearby;

  Destination({
    required this.id_destination,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.description,
    required this.operation,
    required this.maps,
    required this.latitude,
    required this.longitude,
    required this.subCategoryId,
    this.dos = const [],
    this.donts = const [],
    this.safetyGuidelines = const [],
    this.facilities = const [],
    this.sosNearby = const [],
  });
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
    operation: "08:30 - 18:00",
    maps: "https://goo.gl/maps/monkeyforest",
    latitude: -8.519157,
    longitude: 115.263158,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 1),
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
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "Ubud Clinic",
        address: "Jl. Raya Ubud No.36, Gianyar, Bali",
        phone: "+62 361 978 555",
      ),
    ],
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
    operation: "07:00 - 18:00",
    maps: "https://goo.gl/maps/tegallalang",
    latitude: -8.441767,
    longitude: 115.279503,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 2),
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
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "Puskesmas Tegallalang I",
        address: "Jl. Raya Tegallalang, Gianyar, Bali",
        phone: "+62 361 975 456",
      ),
    ],
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
    operation: "08:00 - 17:00",
    maps: "https://goo.gl/maps/goagajah",
    latitude: -8.519221,
    longitude: 115.287021,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 3),
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
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "RS Ari Canti",
        address: "Jl. Raya Mas, Ubud, Gianyar",
        phone: "+62 361 975 833",
      ),
    ],
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
    operation: "24 Jam",
    maps: "https://goo.gl/maps/campuhan",
    latitude: -8.506987,
    longitude: 115.257794,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 4),
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
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "Puskesmas Ubud I",
        address: "Jl. Raya Andong, Peliatan, Gianyar",
        phone: "+62 361 975 123",
      ),
    ],
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
    operation: "08:00 - 18:00",
    maps: "https://goo.gl/maps/saraswati",
    latitude: -8.507604,
    longitude: 115.263289,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 5),
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
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "Ubud Medical Centre",
        address: "Jl. Sukma Kesuma, Peliatan, Ubud",
        phone: "+62 361 974 911",
      ),
    ],
  ),
  Destination(
    id_destination: 6,
    name: "Ubud Palace (Puri Saren Agung)",
    imageUrl: [
      "https://picsum.photos/200/300?11",
      "https://picsum.photos/200/300?12",
    ],
    location: "Jl. Raya Ubud No.8, Gianyar, Bali",
    description: "Istana keluarga kerajaan Ubud yang bersejarah.",
    operation: "08:00 - 18:00",
    maps: "https://goo.gl/maps/ubudpalace",
    latitude: -8.507082,
    longitude: 115.263389,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 6),
    safetyGuidelines: [
      "Hindari menyentuh benda-benda bersejarah",
      "Jaga ketenangan saat ada pertunjukan budaya",
      "Ikuti petunjuk pemandu wisata",
    ],
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "RSU Ubud Care",
        address: "Jl. Raya Campuhan, Ubud, Gianyar",
        phone: "+62 361 977 001",
      ),
    ],
  ),
  Destination(
    id_destination: 7,
    name: "Blanco Renaissance Museum",
    imageUrl: [
      "https://picsum.photos/200/300?13",
      "https://picsum.photos/200/300?14",
    ],
    location: "Campuhan, Ubud",
    description: "Museum seni yang didirikan oleh pelukis Antonio Blanco.",
    operation: "09:00 - 17:00",
    maps: "https://goo.gl/maps/blancomuseum",
    latitude: -8.506033,
    longitude: 115.258739,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 1),
    safetyGuidelines: [
      "Jangan menyentuh karya seni",
      "Gunakan tas kecil untuk menghindari benturan dengan pajangan",
      "Ikuti jalur tur yang ditentukan",
    ],
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "Klinik Ubud II",
        address: "Jl. Raya Sanggingan, Ubud",
        phone: "+62 361 975 122",
      ),
    ],
  ),
  Destination(
    id_destination: 8,
    name: "Museum Puri Lukisan",
    imageUrl: [
      "https://picsum.photos/200/300?15",
      "https://picsum.photos/200/300?16",
    ],
    location: "Jl. Raya Ubud, Gianyar",
    description:
        "Museum tertua di Bali yang menyimpan karya seni rupa Bali klasik.",
    operation: "09:00 - 18:00",
    maps: "https://goo.gl/maps/purilukisan",
    latitude: -8.506943,
    longitude: 115.263137,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 2),
    safetyGuidelines: [
      "Jaga jarak aman dari pajangan seni",
      "Jangan gunakan flash saat memotret",
      "Waspadai lantai licin di musim hujan",
    ],
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "Puskesmas Ubud II",
        address: "Jl. Raya Taman, Ubud, Gianyar",
        phone: "+62 361 977 333",
      ),
    ],
  ),
  Destination(
    id_destination: 9,
    name: "Agung Rai Museum of Art (ARMA)",
    imageUrl: [
      "https://picsum.photos/200/300?17",
      "https://picsum.photos/200/300?18",
    ],
    location: "Jl. Raya Pengosekan, Ubud",
    description:
        "Museum seni dengan koleksi seni rupa tradisional dan modern Bali.",
    operation: "09:00 - 18:00",
    maps: "https://goo.gl/maps/armaubud",
    latitude: -8.523948,
    longitude: 115.268543,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 3),
    safetyGuidelines: [
      "Jangan gunakan flash kamera",
      "Ikuti jalur kunjungan museum",
      "Hindari berlari di area pameran",
    ],
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "RS Ari Canti",
        address: "Jl. Raya Mas, Ubud, Gianyar",
        phone: "+62 361 975 833",
      ),
    ],
  ),
  Destination(
    id_destination: 10,
    name: "Ubud Traditional Art Market",
    imageUrl: [
      "https://picsum.photos/200/300?19",
      "https://picsum.photos/200/300?20",
    ],
    location: "Jl. Raya Ubud, Gianyar",
    description:
        "Pasar seni tradisional yang menjual kerajinan tangan khas Bali.",
    operation: "07:00 - 18:00",
    maps: "https://goo.gl/maps/ubudmarket",
    latitude: -8.507324,
    longitude: 115.263575,
    subCategoryId: subCategories.firstWhere((sc) => sc.id_subCategory == 4),
    dos: [
      "Tawar harga dengan sopan",
      "Dukung pengrajin lokal",
    ],
    donts: [
      "Jangan memaksa penjual menurunkan harga terlalu rendah",
    ],
    safetyGuidelines: [
      "Jaga barang berharga dengan aman",
      "Hindari membawa uang tunai berlebihan",
      "Perhatikan langkah saat area ramai",
    ],
    facilities: [
      Facility(icon: "assets/icons/parking.png", name: "Parking"),
      Facility(icon: "assets/icons/toilet.png", name: "Toilet"),
      Facility(icon: "assets/icons/guide.png", name: "Local Guide"),
      Facility(icon: "assets/icons/photo.png", name: "Photo Area"),
      Facility(icon: "assets/icons/shop.png", name: "Souvenir Shop"),
      Facility(icon: "assets/icons/wheelchair.png", name: "Wheelchair Access"),
    ],
    sosNearby: [
      SosNearby(
        name: "Ubud Clinic",
        address: "Jl. Raya Ubud No.36, Gianyar, Bali",
        phone: "+62 361 978 555",
      ),
    ],
  ),
];