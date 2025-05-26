class MenuItem {
  final String id;
  final String name;
  final String description;
  final String composition;
  final double price;
  final String imageUrl;
  final String category;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.composition,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'composition': composition,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      composition: map['composition'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
    );
  }
}