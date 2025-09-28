import 'package:buynow/features/admin/controllers/product_controller.dart';
import 'package:buynow/features/users/controller/favourite_controller.dart';
import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:buynow/features/users/controller/order_controller.dart';
import 'package:buynow/features/users/home_screen/screen/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../cart/cart_screen.dart';
import '../../favourite_screen/favourite_screen.dart';
import '../../controller/cart_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController homeController;
  final productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    homeController = Get.put(HomeController(), permanent: true);

    Get.put(FavouriteController());
    homeController.getUser();
    Get.put(CartController());
    Get.put(OrderController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     cartController.loadCart();
      //   },
      //   child: Icon(Icons.refresh),
      // ),
      drawer: Builder(
        builder: (context) {
          return DrawerScreen();
        },
      ),
      appBar: AppBar(
        title: Text("HomeScreen"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Get.to(() => FavouriteScreen());
            },
          ),
          GetBuilder<CartController>(
            id: 'cart',
            builder: (controller) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      Get.to(() => CartScreen());
                    },
                  ),
                  if (controller.totalCartProduct() > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          "${controller.totalCartProduct()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: GetBuilder<ProductController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.products.isEmpty) {
            return Center(child: Text("No products available"));
          }
          return ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return Card(
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text("₹${product.price} | Stock: ${product.stock}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GetBuilder<FavouriteController>(
                        id: 'fav-${product.id}',
                        builder: (favCtr) {
                          // print(
                          //   "Rebuilding favourite icon for product id: ${product.id}",
                          // );
                          final isFav = favCtr.isFavourite(product.id!);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              if (homeController.user != null) {
                                await favCtr.toggleFavourite(
                                  homeController.user!.id!,
                                  product,
                                );
                              }
                            },
                          );
                        },
                      ),
                      GetBuilder<CartController>(
                        id: 'cart-${product.id}',
                        builder: (controller) {
                          return IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              controller.addToCart(product.id!);
                            },
                          );
                        },
                      ),
                    ],
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
