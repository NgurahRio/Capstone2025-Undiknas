import 'package:mobile/models/subPackage.dart';
import 'package:mobile/models/destination_model.dart';

class Package {
  final int id_package;
  final Destination destinationId;
  final SubPackage subPackageId;
  final int? price;
  final List<Map<String, String>> includes;
  final List<Map<String, String>> notIncluded;

  Package({
    required this.id_package,
    required this.destinationId,
    required this.subPackageId,
    this.price,
    this.includes = const [],
    this.notIncluded = const [],
  });
}

final List<Package> packages = [
  Package(
    id_package: 1,
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    subPackageId: subPackage.firstWhere((sp) => sp.id_subPackage == 1),
    price: 80000,
    includes: [
      {"icon": "assets/icons/entrance.png", "name": "Entrance fee"},
      {"icon": "assets/icons/traditional.png", "name": "Traditional Balinese attire (sarong & sash) for temple visit"},
      {"icon": "assets/icons/freeParking.png", "name": "Free Parking Lot"},
    ],
    notIncluded: [
      {"icon": "assets/icons/pickup.png", "name": "Pickup / Frop-off to the destination"},
      {"icon": "assets/icons/accommodation.png", "name": "Accommodation / additional lodging"},
    ],
  ),

  Package(
    id_package: 2,
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    subPackageId: subPackage.firstWhere((sp) => sp.id_subPackage == 2),
    price: 120000,
    includes: [
      {"icon": "assets/icons/entrance.png", "name": "Entrance fee"},
      {"icon": "assets/icons/traditional.png", "name": "Traditional Balinese attire (sarong & sash) for temple visit"},
      {"icon": "assets/icons/freeParking.png", "name": "Free Parking Lot"},
    ],
    notIncluded: [
      {"icon": "assets/icons/pickup.png", "name": "Pickup / Frop-off to the destination"},
      {"icon": "assets/icons/accommodation.png", "name": "Accommodation / additional lodging"},
    ],
  ),

  Package(
    id_package: 3,
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    subPackageId: subPackage.firstWhere((sp) => sp.id_subPackage == 3),
    price: 150000,
    includes: [
      {"icon": "assets/icons/entrance.png", "name": "Entrance fee"},
      {"icon": "assets/icons/traditional.png", "name": "Traditional Balinese attire (sarong & sash) for temple visit"},
      {"icon": "assets/icons/freeParking.png", "name": "Free Parking Lot"},
    ],
    notIncluded: [
      {"icon": "assets/icons/pickup.png", "name": "Pickup / Frop-off to the destination"},
      {"icon": "assets/icons/accommodation.png", "name": "Accommodation / additional lodging"},
    ],
  ),

  Package(
    id_package: 4,
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    subPackageId: subPackage.firstWhere((sp) => sp.id_subPackage == 4),
    price: 200000,
    includes: [
      {"icon": "assets/icons/entrance.png", "name": "Entrance fee"},
      {"icon": "assets/icons/traditional.png", "name": "Traditional Balinese attire (sarong & sash) for temple visit"},
      {"icon": "assets/icons/freeParking.png", "name": "Free Parking Lot"},
    ],
    notIncluded: [
      {"icon": "assets/icons/pickup.png", "name": "Pickup / Frop-off to the destination"},
      {"icon": "assets/icons/accommodation.png", "name": "Accommodation / additional lodging"},
    ],
  ),
];
