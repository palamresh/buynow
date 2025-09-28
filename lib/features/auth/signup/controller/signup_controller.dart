import 'package:buynow/database/db_helper.dart';
import 'package:buynow/features/auth/login/screen/login_screen.dart';
import 'package:buynow/features/auth/signup/model/user_model.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  bool isloading = false;
  Future<void> createAccount(UserModel user) async {
    try {
      isloading = true;
      update();
      final DbHelper db = DbHelper.instance;

      int row = await db.createAccount(user);
      if (row > 0) {
        print("user create successful");
        print("Try to Login");
        Get.off(() => LoginScreen());
        isloading = false;

        update();
      } else {
        isloading = false;

        update();
        print("user not create successful");
      }
    } catch (e) {
      isloading = false;

      update();
      print("user create exception $e");
    }
  }
}
