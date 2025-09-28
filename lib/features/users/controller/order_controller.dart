import 'dart:convert';
import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:get/get.dart';

import '../../../database/db_helper.dart';
import '../model/order_item_model.dart';
import '../model/order_model.dart';
import 'address_controller.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  List<OrderModel> orders = [];
  List<OrderItemModel> orderItems = [];
  bool isLoading = false;

  final DbHelper dbHelper = DbHelper.instance;
  final CartController cartController = Get.find<CartController>();
  final HomeController homeController = Get.find<HomeController>();

  // 🔹 Load all orders of a user
  Future<void> loadOrders(int userId) async {
    try {
      isLoading = true;
      update();
      orders = await dbHelper.getOrders(userId);
    } catch (e) {
      print("Error loading orders: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  // 🔹 Place order
  Future<int?> placeOrder({
    required String paymentMethod,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignatureId,
  }) async {
    try {
      isLoading = true;
      update();

      // Address ko JSON form me save karo
      final addressController = Get.find<AddressController>();
      final defaultAddress = addressController.defaultAddress;
      if (defaultAddress == null) {
        Get.snackbar("Error", "Please select an address before placing order");
        return null;
      }

      final addressJson = jsonEncode(defaultAddress.toMap());

      // 1️⃣ Create Order
      final order = OrderModel(
        userId: homeController.user!.id!,
        addressJson: addressJson,
        totalAmount: cartController.totalCartPrice(),
        paymentMethod: paymentMethod,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignatureId: razorpaySignatureId,
      );

      final orderId = await dbHelper.insertOrder(order);

      // 2️⃣ Add Order Items from Cart

      for (var item in cartController.cartItems) {
        final orderItem = OrderItemModel(
          orderId: orderId,
          productId: item.productId,
          productName: item.productName,
          price: item.productPrice,
          quantity: item.quantity,
          image: item.productImage,
        );
        await dbHelper.insertOrderItem(orderItem);
      }

      // 3️⃣ Clear cart after order placed
      for (var item in cartController.cartItems) {
        await dbHelper.removeFromCart(homeController.user!.id!, item.productId);
      }
      cartController.cartItems.clear();
      cartController.update(['cart']);

      Get.snackbar("Success", "Order placed successfully!");
      await loadOrders(homeController.user!.id!); // refresh orders

      return orderId;
    } catch (e) {
      print("Error placing order: $e");
      Get.snackbar("Error", "Failed to place order");
      return null;
    } finally {
      isLoading = false;
      update();
    }
  }

  // 🔹 Get items of a particular order
  Future<void> loadOrderItems(int orderId) async {
    try {
      isLoading = true;
      update();
      orderItems = await dbHelper.getOrderItems(orderId);
    } catch (e) {
      print("Error loading order items: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  // 🔹 Update order status
  Future<void> updateStatus(int orderId, String status) async {
    await dbHelper.updateOrderStatus(orderId, status);
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      orders[index].status = status;
      update();
    }
  }

  // 🔹 Delete order
  Future<void> deleteOrder(int orderId) async {
    await dbHelper.deleteOrder(orderId);
    orders.removeWhere((o) => o.id == orderId);
    update();
  }
}
