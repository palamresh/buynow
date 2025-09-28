class AddressModel {
  int? id;
  int userId;
  String addressLine1;
  String city;
  String state;
  String country;
  String pincode;
  int isDefault;
  String? createdAt;

  AddressModel({
    this.id,
    required this.userId,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    this.isDefault = 0,
    this.createdAt,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      userId: map['user_id'],
      addressLine1: map['address_line1'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      pincode: map['pincode'],
      isDefault: map['is_default'] ?? 0,
      createdAt: map['create_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'address_line1': addressLine1,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'is_default': isDefault,
      'create_at': createdAt,
    };
  }
}
