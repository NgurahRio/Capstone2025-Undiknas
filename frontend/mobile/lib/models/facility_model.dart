import 'dart:typed_data';

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