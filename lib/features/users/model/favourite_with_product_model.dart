// import '../../admin/model/product_model.dart';
// import 'favourite_model.dart';

// class FavouriteWithProduct {
//   final FavouriteModel favourite;
//   final ProductModel product;

//   FavouriteWithProduct({required this.favourite, required this.product});

//   factory FavouriteWithProduct.fromMap(Map<String, dynamic> map) {
//     return FavouriteWithProduct(
//       favourite: FavouriteModel(
//         id: map['fav_id'],
//         userId: map['user_id'],
//         productId: map['product_id'],
//         createdAt: DateTime.parse(map['create_at']),
//       ),
//       product: ProductModel(
//         id: map['product_id'],
//         categoryId: map['category_id'],
//         name: map['name'],
//         image: map['image'],
//         price:
//             map['price'] is int
//                 ? (map['price'] as int).toDouble()
//                 : map['price'] as double,
//         stock: map['stock'],
//       ),
//     );
//   }
// }

import 'package:buynow/features/admin/model/product_model.dart';

class FavouriteWithProduct {
  final int favId;
  final int userId;
  final int productId;
  final DateTime createdAt;
  final ProductModel product;

  FavouriteWithProduct({
    required this.favId,
    required this.userId,
    required this.productId,
    required this.createdAt,
    required this.product,
  });

  factory FavouriteWithProduct.fromMap(Map<String, dynamic> map) {
    return FavouriteWithProduct(
      favId: map['fav_id'] as int,
      userId: map['user_id'] as int,
      productId: map['product_id'] as int,
      createdAt: DateTime.tryParse(map['create_at'] ?? "") ?? DateTime.now(),
      product: ProductModel(
        id: map['product_id'] as int,
        categoryId: map['category_id'] as int,
        name: map['name'] as String? ?? "",
        description:
            map['description'] != null ? map['description'] as String : "",
        price:
            map['price'] is int
                ? (map['price'] as int).toDouble()
                : (map['price'] as double? ?? 0.0),
        stock: map['stock'] as int? ?? 0,
        image: map['image'] != null ? map['image'] as String : "",
      ),
    );
  }
}
