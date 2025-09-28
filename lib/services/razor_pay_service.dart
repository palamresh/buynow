import 'dart:convert';

import 'package:buynow/features/users/controller/cart_controller.dart';
import 'package:buynow/features/users/controller/home_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:crypto/crypto.dart';

import '../features/users/controller/order_controller.dart';
import '../features/users/home_screen/screen/home_screen.dart';

class PaymentService {
  static final _instance = PaymentService._internal();
  String keyID = "rzp_test_TXuWjyJ7mDCpGd";
  String secretKey = "1Erv9zh4aB22mXrkYzGnhQHN";
  late Razorpay _razorpay;
  factory PaymentService() {
    return _instance;
  }

  PaymentService._internal() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void dispose() {
    _razorpay.clear();
  }

  Future<String?> createOrder(double amount) async {
    final dio = Dio();
    final amountInPaisa = amount * 100;
    final url = "https://api.razorpay.com/v1/orders";
    final header = {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$keyID:$secretKey'))}',
    };
    final body = {
      'amount': amountInPaisa.toInt(),
      'currency': 'INR',
      'receipt': 'receipt#1${DateTime.now().millisecondsSinceEpoch}',
      'payment_capture': 1,
    };
    try {
      final response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(headers: header),
      );
      if (response.statusCode == 200) {
        final orderId = response.data;
        return orderId['id'];
      }
    } catch (e) {
      print("Dio Exception $e");
    }
    return null;
  }

  void openCheckout({
    required double amount,
    required String name,
    String description = "",
    required String contact,
    required String email,
    required String? orderId,
  }) {
    var options = {
      'key': "rzp_test_TXuWjyJ7mDCpGd",
      'amount': (amount * 100).toInt(), // paise me (50000 = 500.00 INR)
      'name': name,
      'order_id': orderId,
      'description': description,
      'prefill': {'contact': contact, 'email': email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay open error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment successful: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");
    bool isValid = verifyPayment(
      response.orderId!,
      response.paymentId!,
      response.signature!,
      secretKey,
    );
    if (isValid) {
      print("Payment is valid and verified.");
      final orderCtr = Get.find<OrderController>();

      orderCtr.placeOrder(
        // Replace with actual amount
        paymentMethod: "Razorpay",
        razorpayOrderId: response.orderId,
        razorpayPaymentId: response.paymentId,
        razorpaySignatureId: response.signature,
      );
      Get.offAll(() => HomeScreen()); // Close the payment screen
    } else {
      print("Payment verification failed.");
    }
    // Do something when payment succeeds
  }

  bool verifyPayment(
    String orderId,
    String paymentId,
    String razorpaySignature,
    String secret,
  ) {
    final key = utf8.encode(secret);
    final msg = utf8.encode('$orderId|$paymentId');

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(msg);

    final generatedSignature = digest.toString();

    return generatedSignature == razorpaySignature;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed: ${response.code} - ${response.message}");
    Get.back();
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet selected: ${response.walletName}");
    // Do something when an external wallet was selected
  }
}
