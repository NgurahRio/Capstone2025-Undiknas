class Facility {
  final int id_facility;
  final String icon;
  final String name;

  Facility({
    required this.id_facility,
    required this.icon, 
    required this.name,
  });
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