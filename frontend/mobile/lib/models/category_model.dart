class Category {
  final int id_category;
  final String name;

  Category({
    required this.id_category, 
    required this.name
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id_category: json['id_categories'],
      name: json['name'],
    );
  }
}

final List<Category> categories = [
  Category(id_category: 1, name: "Adventure"),
  Category(id_category: 2, name: "Culture"),
];