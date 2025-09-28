class OrderItemModel {
  int? id;
  int orderId;
  int productId;
  String productName;
  double price;
  int quantity;
  String? image;

  OrderItemModel({
    this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quntity': quantity,
      'image': image,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      productName: map['product_name'],
      price: map['price'],
      quantity: map['quntity'],
      image: map['image'],
    );
  }
}
