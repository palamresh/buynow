import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';

import 'add_edit_product.dart';

class ProductsScreen extends StatelessWidget {
  final productCtr = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddEditProductScreen()),
        child: Icon(Icons.add),
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
                  trailing: PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(value: "edit", child: Text("Edit")),
                          PopupMenuItem(value: "delete", child: Text("Delete")),
                        ],
                    onSelected: (value) {
                      if (value == "edit") {
                        Get.to(
                          () => AddEditProductScreen(productModel: product),
                        );
                      } else {
                        controller.deleteProduct(product.id!);
                      }
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
