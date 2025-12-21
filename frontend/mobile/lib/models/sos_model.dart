class SOS {
  final int id_sos;
  final String name;
  final String address;
  final String phone;

  SOS({
    required this.id_sos,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory SOS.fromJson(Map<String, dynamic> json) {
    return SOS(
      id_sos: json['id_sos'],
      name: json['name_sos'],
      address: json['alamat_sos'],
      phone: json['telepon'],
    );
  }
}

final List<SOS> sos = [
  SOS(
    id_sos: 1,
    name: "Ubud Clinic",
    address: "Jl. Raya Ubud No.36, Gianyar, Bali",
    phone: "+62361978555",
  ),
  SOS(
    id_sos: 2,
    name: "Puskesmas Tegallalang I",
    address: "Jl. Raya Tegallalang, Gianyar, Bali",
    phone: "+62 361 975 456",
  ),
  SOS(
    id_sos: 3,
    name: "RS Ari Canti",
    address: "Jl. Raya Mas, Ubud, Gianyar",
    phone: "+62 361 975 833",
  ),
  SOS(
    id_sos: 4,
    name: "Puskesmas Ubud I",
    address: "Jl. Raya Andong, Peliatan, Gianyar",
    phone: "+62 361 975 123",
  ),
  SOS(
    id_sos: 5,
    name: "Ubud Medical Centre",
    address: "Jl. Sukma Kesuma, Peliatan, Ubud",
    phone: "+62 361 974 911",
  ),
];