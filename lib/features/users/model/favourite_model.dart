class FavouriteModel {
  final int? id;
  final int userId;
  final int productId;
  final String? createdAt;

  FavouriteModel({
    this.id,
    required this.userId,
    required this.productId,
    this.createdAt,
  });

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      productId: map['product_id'] as int,
      createdAt: map['create_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'create_at': createdAt,
    };
  }
}
