class OrderModel {
  int? id;
  int userId;
  String addressJson;
  double totalAmount;
  String status;
  String? paymentMethod;
  String? razorpayOrderId;
  String? razorpayPaymentId;
  String? razorpaySignatureId;

  OrderModel({
    this.id,
    required this.userId,
    required this.addressJson,
    required this.totalAmount,
    this.status = 'pending',
    this.paymentMethod,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignatureId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'address': addressJson,
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature_id': razorpaySignatureId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userId: map['user_id'],
      addressJson: map['address'],
      totalAmount: map['total_amount'],
      status: map['status'],
      paymentMethod: map['payment_method'],
      razorpayOrderId: map['razorpay_order_id'],
      razorpayPaymentId: map['razorpay_payment_id'],
      razorpaySignatureId: map['razorpay_signature_id'],
    );
  }
}
