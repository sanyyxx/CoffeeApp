class Coupon {
  final String id;
  final String name;
  final int bonusPrice;
  final String description;

  Coupon({
    required this.id,
    required this.name,
    required this.bonusPrice,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bonusPrice': bonusPrice,
      'description': description,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bonusPrice: map['bonusPrice'] ?? 0,
      description: map['description'] ?? '',
    );
  }
}