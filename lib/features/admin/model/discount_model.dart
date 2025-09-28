class DiscountModel {
  final int? id;
  final String name;
  final double percentage;
  final String? createdAt; // SQLite auto fills this

  DiscountModel({
    this.id,
    required this.name,
    required this.percentage,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'percentage': percentage,
      'create_at': createdAt,
    };
  }

  factory DiscountModel.fromMap(Map<String, dynamic> map) {
    return DiscountModel(
      id: map['id'],
      name: map['name'],
      percentage:
          (map['percentage'] is int)
              ? (map['percentage'] as int).toDouble()
              : map['percentage'],
      createdAt: map['create_at'],
    );
  }
}
