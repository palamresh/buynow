import 'package:buynow/database/db_helper.dart';
import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:get/get.dart';
import '../../../database/sessing_manager.dart';
import '../address/address_screen.dart';
import '../model/cart_item_model.dart';

class CartController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  List<CartItemModel> cartItems = [];
  bool isLoading = false;

  // tumhara DB instance
  Future<void> loadCart() async {
    if (homeController.user == null) {
      print("user null");
      return;
    }
    try {
      isLoading = true;
      update(['cart']);
      cartItems = await DbHelper.instance.getCartItems(
        homeController.user!.id!,
      );
      print("user cart item get"); // userId ko dynamic banao
      update(['cart']); // UI ko update karo
    } catch (e) {
      print("Error loading cart items: $e");
    } finally {
      isLoading = false;
      update(['cart']);
    }
  }

  Future<void> addToCart(int productId) async {
    if (homeController.user == null) return;

    try {
      isLoading = true;
      update(['cart-$productId', "cart"]);

      final userId = homeController.user!.id!;
      await DbHelper.instance.addToCart(userId, productId).then((value) async {
        if (value > 0) {
          Get.snackbar("Success", "Product added to cart");

          await loadCart();
        } else {
          print("Product already in cart");
          Get.snackbar(
            "Already in Cart",
            "This product is already in your cart",
          );
        }
      });

      // Reload cart
    } catch (e) {
      print("Error adding to cart: $e");
    } finally {
      isLoading = false;
      update(['cart-$productId', "cart"]);
    }
  }

  Future<void> updateQuantity(int userId, int productId, int quantity) async {
    try {
      int index = cartItems.indexWhere((item) => item.productId == productId);
      if (index != -1) {
        cartItems[index].quantity = quantity;

        update(["qty-$productId", "cart"]); // UI ko update karo
      }
      await DbHelper.instance.updateQuantity(userId, productId, quantity);
    } catch (e) {
      print("Error updating cart item quantity: $e");
    }
  }

  Future<void> removeFromCart(int userId, int productId) async {
    try {
      cartItems.removeWhere((item) => item.productId == productId);
      update(['cart']); // UI ko update karo
      await DbHelper.instance.removeFromCart(userId, productId);
    } catch (e) {
      print("Error removing cart item: $e");
    }
  }

  int totalCartProduct() {
    return cartItems.length;
  }

  double totalCartPrice() {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void navigateToAddressScreen() {
    Get.to(
      () => AddressScreen(
        userId: homeController.user!.id!,
        totalAmount: totalCartPrice(),
      ),
    );
  }

  @override
  void onInit() {
    loadCart();
    super.onInit();
  }
}
