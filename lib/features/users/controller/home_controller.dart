import 'package:buynow/database/sessing_manager.dart';
import 'package:buynow/features/admin/controllers/categories_controller.dart';
import 'package:buynow/features/auth/signup/model/user_model.dart';
import 'package:buynow/features/users/controller/cart_controller.dart';
import 'package:buynow/utils/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'favourite_controller.dart';

class HomeController extends GetxController {
  UserModel? user;

  Future<void> getUser() async {
    try {
      user = await SessionManager.getUser();
      print("get user method called");
      update();
      if (user != null) {
        print("Loading favourites for user id: ${user!.id}");
        Get.find<FavouriteController>().loadFavourites();
        Get.find<CartController>().loadCart();
      }
    } catch (e) {
      print("Error getting user: $e");
    } finally {}
  }
}
