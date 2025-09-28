class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password; // यहाँ तुम चाहो तो hashPassword(password) रख सकते हो
  final String? phone;
  final String? role;
  final String? createdAt;
  final int? discountId; // foreign key reference to discounts

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.role = "user",
    this.createdAt,
    this.discountId,
  });

  /// Convert UserModel -> Map (for inserting/updating in DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'create_at': createdAt,
      'discount_id': discountId,
    };
  }

  /// Convert Map -> UserModel (when fetching from DB)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      role: map['role'] ?? 'user',
      createdAt: map['create_at'],
      discountId: map['discount_id'],
    );
  }
}
