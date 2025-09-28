import 'dart:io';
import 'package:buynow/features/admin/model/product_model.dart';
import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:buynow/features/users/model/favourite_model.dart';
import 'package:buynow/features/users/model/favourite_with_product_model.dart';
import 'package:buynow/utils/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../../../database/db_helper.dart';

class FavouriteController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  List<FavouriteWithProduct> favourites = [];
  List<int> favouriteProductIds = [];
  bool isloading = false;

  /// 🔹 Load all favourites for a user
  Future<void> loadFavourites() async {
    if (homeController.user == null) return;

    try {
      isloading = true;

      update(['favourites']);
      favourites = await DbHelper.instance.getUserFavourites(
        homeController.user!.id!,
      );

      favouriteProductIds = favourites.map((e) => e.productId).toList();
    } catch (e) {
      print("Error loading favourites: $e");
    } finally {
      isloading = false;
      update(['favourites']);
    }
  }

  /// 🔹 Toggle favourite from HomeScreen
  Future<void> toggleFavourite(int userId, ProductModel product) async {
    if (favouriteProductIds.contains(product.id)) {
      await removeFavourite(userId, product.id!);
    } else {
      await addFavourite(userId, product);
    }
  }

  /// 🔹 Add favourite
  Future<void> addFavourite(int userId, ProductModel product) async {
    try {
      isloading = true;
      update(['fav-${product.id}']);

      await DbHelper.instance.addFavourite(
        FavouriteModel(userId: userId, productId: product.id!),
      );

      favourites = await DbHelper.instance.getUserFavourites(userId);

      favouriteProductIds = favourites.map((f) => f.productId).toList();
    } catch (e) {
      print("Error adding favourite: $e");
    } finally {
      isloading = false;
      update(['fav-${product.id}']);
    }
  }

  /// 🔹 Remove favourite
  Future<void> removeFavourite(int userId, int productId) async {
    try {
      // isloading = true;
      update(['fav-$productId', "favourites"]);

      await DbHelper.instance.removeFromFavourites(userId, productId);

      favourites.removeWhere((f) => f.productId == productId);
      favouriteProductIds.remove(productId);
    } catch (e) {
      print("Error removing favourite: $e");
    } finally {
      // isloading = false;
      update(['fav-$productId', "favourites"]);
    }
  }

  /// 🔹 Check if product is favourite
  bool isFavourite(int productId) {
    return favouriteProductIds.contains(productId);
  }
}
