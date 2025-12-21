import 'package:mobile/models/subPackage.dart';
import 'package:mobile/models/destination_model.dart';

class Package {
  final int id_package;
  final Destination destinationId;
  final Map<SubPackage, Map<String, dynamic>> subPackages;

  Package({
    required this.id_package,
    required this.destinationId,
    required this.subPackages,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    final destination = Destination.fromJson(json['destination']);

    final List subpackageList = json['subpackages'];
    final Map<String, dynamic> subpackageData = json['subpackage_data'];

    final Map<int, SubPackage> subMap = {
      for (var sp in subpackageList)
        sp['id_subpackage']: SubPackage.fromJson(sp)
    };

    final Map<SubPackage, Map<String, dynamic>> result = {};

    subpackageData.forEach((key, value) {
      final int subId = int.parse(key);

      final subPackage = subMap[subId];
      if (subPackage != null) {
        result[subPackage] = {
          "price": value['price'],
          "include": value['include'],
        };
      }
    });

    return Package(
      id_package: json['id_packages'],
      destinationId: destination,
      subPackages: result,
    );
  }
}

final List<Package> packages = [
  Package(
    id_package: 1,
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
    subPackages: {
      subPackage[0]: {
        "price": 50000,
        "include": [
          {
            "image": "assets/icons/entrance.png", 
            "name": "Entrance Ticket"}
        ],
      },
      subPackage[1]: {
        "price": 75000,
        "include": [
          {
            "image": "assets/icons/guide.png", 
            "name": "Local Guide"},
        ],
      },
    },
  )
];
