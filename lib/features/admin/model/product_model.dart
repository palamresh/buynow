class ProductModel {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String image;
  final int categoryId;
  final int isActive;
  final String? createAt;
  final String? updateAt;

  ProductModel({
    this.id,
    required this.name,
    this.description,
    required this.price,
    this.stock = 0,
    required this.image,
    required this.categoryId,
    this.isActive = 1,
    this.createAt,
    this.updateAt,
  });

  /// ✅ Convert Map to ProductModel
  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
      categoryId: json['category_id'],
      isActive: json['is_active'],
      createAt: json['create_at'],
      updateAt: json['update_at'],
    );
  }

  /// ✅ Convert ProductModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
      'category_id': categoryId,
      'is_active': isActive,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
