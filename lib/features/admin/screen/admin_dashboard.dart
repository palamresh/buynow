import 'package:buynow/database/sessing_manager.dart';
import 'package:buynow/features/admin/screen/discount/discount_screen.dart';
import 'package:buynow/features/admin/screen/category/categories_screen.dart';
import 'package:buynow/features/admin/screen/products/product_screen.dart';
import 'package:buynow/features/admin/screen/users_screen/user_screen.dart';

import 'package:buynow/features/auth/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Dummy counts (replace with DB data)
  int users = 120;
  int products = 85;
  int categories = 12;
  int orders = 230;
  int discounts = 5;

  int pendingOrders = 25;
  int shippedOrders = 40;
  int deliveredOrders = 150;
  int canceledOrders = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: () async {
              SessionManager.logout().then((value) {
                Get.off(() => const LoginScreen());
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Cards (Clickable)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true, // fix for overflow
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildDashboardCard("Users", users, Icons.person, () {
                  Get.to(() => UserScreen());
                }),
                _buildDashboardCard("Discounts", discounts, Icons.discount, () {
                  Get.to(() => DiscountScreen());
                }),
                _buildDashboardCard(
                  "Categories",
                  categories,
                  Icons.category,
                  () {
                    Get.to(() => CategoriesScreen());
                  },
                ),
                _buildDashboardCard(
                  "Products",
                  products,
                  Icons.shopping_bag,
                  () {
                    Get.to(() => ProductsScreen());
                  },
                ),

                _buildDashboardCard("Orders", orders, Icons.shopping_cart, () {
                  Get.to(() => const ManageOrdersScreen());
                }),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Order Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true, // fix for overflow
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildStatusCard("Pending", pendingOrders, Colors.orange),
                _buildStatusCard("Shipped", shippedOrders, Colors.blue),
                _buildStatusCard("Delivered", deliveredOrders, Colors.green),
                _buildStatusCard("Canceled", canceledOrders, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    int count,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                "$count",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, int count, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              "$count",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Placeholder Management Screens =====

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text("Manage Products")));
}

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text("Manage Categories")));
}

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text("Manage Orders")));
}
