import 'package:buynow/database/db_helper.dart';
import 'package:buynow/database/sessing_manager.dart';
import 'package:buynow/features/admin/screen/admin_dashboard.dart';
import 'package:buynow/features/auth/signup/model/user_model.dart';
import 'package:buynow/features/users/home_screen/screen/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginController extends GetxController {
  bool isloading = false;
  Future<void> login(String email, String password) async {
    isloading = true;
    update();
    try {
      final db = DbHelper.instance;
      UserModel? user = await db.loginUser(email, password);
      SessionManager.saveUser(user!);
      if (user.role == "user") {
        Get.offAll(() => HomeScreen());
      } else {
        Get.off(() => AdminDashboard());
      }
    } catch (e) {
      print(e);
    } finally {
      isloading = false;
      update();
    }
  }
}
