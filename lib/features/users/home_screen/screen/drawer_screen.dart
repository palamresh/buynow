import 'package:buynow/database/sessing_manager.dart';
import 'package:buynow/features/auth/login/screen/login_screen.dart';
import 'package:buynow/features/auth/signup/model/user_model.dart';
import 'package:buynow/features/users/cart/cart_screen.dart';
import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../favourite_screen/favourite_screen.dart';
import '../../orders/my_order_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(
                  controller.user?.name ?? "Guest User",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                accountEmail: Text(
                  controller.user?.email ?? "guest@example.com",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      controller.user?.name[0].toUpperCase() ?? "G",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.deepPurple),
                title: Text("Add Cart"),
                onTap: () {
                  Get.to(() => CartScreen());
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: Colors.deepPurple),
                title: Text("Favourite"),
                onTap: () {
                  Get.to(() => FavouriteScreen());
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt_long, color: Colors.deepPurple),
                title: Text("Orders"),
                onTap: () {
                  Get.to(() => OrderScreen());
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Logout"),
                onTap: () async {
                  SessionManager.logout().then((value) {
                    print("logout successfully");
                    Get.offAll(LoginScreen());
                  });

                  // handle logout
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
