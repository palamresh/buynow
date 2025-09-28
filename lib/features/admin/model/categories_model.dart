class CategoryModel {
  final int? id;
  final String name;
  final int isActive; // 1 = active, 0 = inactive
  final String? createdAt; // SQLite auto fills this

  CategoryModel({
    this.id,
    required this.name,
    this.isActive = 1,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
      'create_at': createdAt,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      isActive: map['is_active'] ?? 1,
      createdAt: map['create_at'],
    );
  }
}
