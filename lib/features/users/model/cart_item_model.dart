class CartItemModel {
  int id;
  int userId; // add user_id
  int productId; // add product_id
  int quantity;
  String? createdAt;
  String? updatedAt;

  // Product info
  String productName;
  double productPrice;
  String productImage;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.createdAt,
    this.updatedAt,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });
  double get totalPrice => productPrice * quantity;

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      createdAt: map['create_at'],
      updatedAt: map['update_at'],
      productName: map['name'],
      productPrice:
          map['price'] is int
              ? (map['price'] as int).toDouble()
              : map['price'] as double,
      productImage: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'create_at': createdAt,
      'update_at': updatedAt,
      'name': productName,
      'price': productPrice,
      'image': productImage,
    };
  }
}
