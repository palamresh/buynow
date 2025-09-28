// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/razor_pay_service.dart';
import '../address/address_screen.dart';
import '../controller/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final paymentService = PaymentService();
  @override
  Widget build(BuildContext context) {
    final cartCtr = Get.find<CartController>();
    @override
    void initState() {
      print("Cart screen initState called");

      cartCtr.loadCart();

      super.initState();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        actions: [
          IconButton(icon: Icon(Icons.delete_forever), onPressed: () {}),
        ],
      ),
      body: GetBuilder<CartController>(
        id: 'cart',
        builder: (controller) {
          if (controller.cartItems.isEmpty) {
            return Center(child: Text("Your cart is empty"));
          }
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: GetBuilder<CartController>(
                        id: "qty-${item.productId}",
                        builder: (controller) {
                          return ListTile(
                            title: Text(item.productName),
                            subtitle: Text(
                              "₹${item.productPrice} x ${item.quantity} = ₹${item.totalPrice}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed:
                                      item.quantity > 1
                                          ? () {
                                            cartCtr.updateQuantity(
                                              item.userId,
                                              item.productId,
                                              item.quantity - 1,
                                            );
                                          }
                                          : null,
                                ),
                                Text("${item.quantity}"),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    cartCtr.updateQuantity(
                                      item.userId,
                                      item.productId,
                                      item.quantity + 1,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    cartCtr.removeFromCart(
                                      item.userId,
                                      item.productId,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[200],
                child: GetBuilder<CartController>(
                  id: "cart",
                  builder: (ctr) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total: ₹${ctr.totalCartPrice().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            cartCtr.navigateToAddressScreen();
                            // paymentService.openCheckout(
                            //   amount: ctr.totalCartPrice(),
                            //   name: "Test User",
                            //   contact: "1523654847",
                            //   email: "test@gmail.com",
                            // );
                          },
                          child: Text("Checkout"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
