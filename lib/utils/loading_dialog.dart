import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog {
  static void show({String? message}) {
    if (Get.isDialogOpen == true) return; // already open to avoid duplicate

    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              if (message != null) ...[
                SizedBox(height: 16),
                Text(message, style: TextStyle(fontSize: 16)),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
