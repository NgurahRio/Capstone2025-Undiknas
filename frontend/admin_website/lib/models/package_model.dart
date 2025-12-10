import 'package:admin_website/models/destination_model.dart';
import 'package:admin_website/models/subPackage_model.dart';

class Package {
  final int id_package;
  final Destination destinationId;
  final List<SubPackage> subPackage;
  final Map<int, int> subPackagePrices;
  final Map<int, List<Map<String, String>>> includes;


  Package({
    required this.id_package,
    required this.destinationId,
    required this.subPackage ,
    required this.subPackagePrices,
    this.includes = const {},
  });

  int getPrice(int subPackageId) {
    return subPackagePrices[subPackageId] ?? 0;
  }
}

List<SubPackage>getSubPackage(List<int> idSubp) {
  return subPackages.where((subp) => idSubp.contains(subp.id_subPackage)).toList();
}

final List<Package> packages = [
  Package(
    id_package: 1,
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    
    subPackage: getSubPackage([1, 2, 3]),

    subPackagePrices: {
      1: 50000,
      2: 75000,
      3: 40000,
    },

    includes: {
      1: [
        {"icon": "assets/icons/entrance.png", "name": "Entrance Ticket"},
      ],
      2: [
        {"icon": "assets/icons/entrance.png", "name": "Entrance Fee"},
        {"icon": "assets/icons/guide.png", "name": "Local Guide"},
      ],
      3: [
        {"icon": "assets/icons/entrance.png", "name": "Entrance Fee"},
      ],
    },
  )
];