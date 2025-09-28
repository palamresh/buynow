import 'dart:io';

import 'package:buynow/features/admin/model/product_model.dart';
import 'package:buynow/features/users/controller/favourite_controller.dart';
import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:buynow/utils/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavouriteController favController = Get.find<FavouriteController>();

  final HomeController homeController = Get.find<HomeController>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeController.user != null) {
        favController.loadFavourites();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Agar user null hai to pehle load karenge

    return Scaffold(
      appBar: AppBar(title: Text("My Favourites")),
      body: GetBuilder<FavouriteController>(
        id: 'favourites',
        builder: (_) {
          if (favController.favourites.isEmpty) {
            return Center(child: Text("No favourites yet."));
          }

          if (favController.isloading) {
            return Center(child: CircularProgressIndicator());
          }
          if (homeController.user == null) {
            return Center(child: Text("Please login to view favourites"));
          }

          return ListView.builder(
            itemCount: favController.favourites.length,
            itemBuilder: (context, index) {
              final favItem = favController.favourites[index];
              final product = favItem.product;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text("₹${product.price} | Stock: ${product.stock}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      try {
                        await favController.removeFavourite(
                          homeController.user!.id!,
                          product.id!,
                        );

                        Get.snackbar(
                          "Removed",
                          "${product.name} removed from favourites",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } catch (e) {
                        print("Error removing favourite: $e");
                      } finally {}
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
