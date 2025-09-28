import 'dart:async';
import 'package:buynow/database/sessing_manager.dart';
import 'package:buynow/features/admin/screen/admin_dashboard.dart';
import 'package:buynow/features/auth/login/screen/login_screen.dart';
import 'package:buynow/features/auth/signup/model/user_model.dart';
import 'package:buynow/features/users/home_screen/screen/home_screen.dart';
import 'package:get/get.dart';

class SplashService {
  void isLogin() async {
    final userLogin = await SessionManager.islogin();
    if (userLogin) {
      UserModel? userModel = await SessionManager.getUser();
      if (userModel?.role == "user") {
        print("user role ${userModel?.role}");
        Timer(Duration(seconds: 3), () {
          Get.offAll(() => HomeScreen());
        });
      } else {
        Timer(Duration(seconds: 3), () {
          Get.offAll(() => AdminDashboard());
        });
      }
    } else {
      Timer(Duration(seconds: 3), () {
        Get.offAll(() => LoginScreen());
      });
    }
  }
}
