class SubPackage {
  final int id_subPackage;
  final String name;
  final String icon;

  SubPackage({
    required this.id_subPackage,
    required this.name,
    required this.icon
  });

  factory SubPackage.fromJson(Map<String, dynamic> json) {
    return SubPackage(
      id_subPackage: json['id_subpackage'],
      name: json['jenispackage'],
      icon: json['image'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubPackage &&
          runtimeType == other.runtimeType &&
          id_subPackage == other.id_subPackage;

  @override
  int get hashCode => id_subPackage.hashCode;
}

final List<SubPackage> subPackage = [
  SubPackage(
    id_subPackage: 1, 
    name: "Solo Trip", 
    icon: "assets/icons/solo.png"
  ),
  SubPackage(
    id_subPackage: 2, 
    name: "Romantic Gateway", 
    icon: "assets/icons/romantic.png"
  ),
  SubPackage(
    id_subPackage: 3, 
    name: "Family Package", 
    icon: "assets/icons/family.png"
  ),
  SubPackage(
    id_subPackage: 4, 
    name: "Group Tour", 
    icon: "assets/icons/group.png"
  ),
];