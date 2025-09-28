import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/signup/model/user_model.dart';

class SessionManager {
  static const String keyIsLoggedIn = "isLoggedIn";
  static const String keyUserId = "userId";
  static const String keyUserName = "userName";
  static const String keyUserEmail = "userEmail";
  static const String keyUserRole = "userRole";

  // Save session
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLoggedIn, true);
    await prefs.setInt(keyUserId, user.id!);
    await prefs.setString(keyUserName, user.name);
    await prefs.setString(keyUserEmail, user.email);
    await prefs.setString(keyUserRole, user.role!);
  }

  // Get session
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return null;

    return UserModel(
      id: prefs.getInt(keyUserId),
      name: prefs.getString(keyUserName) ?? "",
      email: prefs.getString(keyUserEmail) ?? "",
      password: "", // password store nahi karna
      role: prefs.getString(keyUserRole) ?? "user",
    );
  }

  // Clear session (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> islogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(keyIsLoggedIn) ?? false;
  }
}
