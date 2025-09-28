import 'dart:convert';
import 'dart:io';
import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/order_controller.dart';
import '../model/order_item_model.dart';

class OrderScreen extends StatelessWidget {
  final orderController = Get.put(OrderController());
  final homeController = Get.find<HomeController>();

  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Orders load karo screen khulte hi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.loadOrders(homeController.user?.id ?? 0);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),
      body: GetBuilder<OrderController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.orders.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          return ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              final address = jsonDecode(order.addressJson);

              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(side: BorderSide.none),

                  title: Text("Order #${order.id} - ₹${order.totalAmount}"),
                  subtitle: Text(
                    "Status: ${order.status}\n"
                    "Payment: ${order.paymentMethod ?? 'N/A'}\n"
                    "OrderId : ${order.razorpayOrderId ?? 'N/A'}",
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        "Address: ${address['address_line1']}, "
                        "${address['city']}, ${address['state']}",
                      ),
                    ),

                    // 🔹 Use FutureBuilder to load order items
                    FutureBuilder<List<OrderItemModel>>(
                      future: orderController.dbHelper.getOrderItems(order.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("No items found"),
                          );
                        }

                        final items = snapshot.data!;
                        return Column(
                          children:
                              items.map((item) {
                                return ListTile(
                                  title: Text(item.productName),
                                  subtitle: Text(
                                    "₹${item.price} x ${item.quantity} = ₹${item.price * item.quantity}    ",
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
