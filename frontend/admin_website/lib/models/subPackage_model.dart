class SubPackage {
  final int id_subPackage;
  final String name;
  final String icon;

  SubPackage({
    required this.id_subPackage,
    required this.name,
    required this.icon
  });
}

final List<SubPackage> subPackages = [
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