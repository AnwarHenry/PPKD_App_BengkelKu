import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const String loginKey = "is_logged_in";
  static const String tokenKey = "auth_token";
  static const String userIdKey = "user_id";
  static const String userNameKey = "user_name";
  static const String userEmailKey = "user_email";

  // Login Methods
  static Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, true);
  }

  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }

  static Future<void> removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(loginKey);
  }

  // Token Methods
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // User Data Methods
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  static Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, userName);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<void> saveUserEmail(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmailKey, userEmail);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // update profile user
  static Future<void> saveUserProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile_image', imagePath);
  }

  static Future<String?> getUserProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_profile_image');
  }

  static Future<void> saveUserCreatedAt(String createdAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_created_at', createdAt);
  }

  static Future<String?> getUserCreatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_created_at');
  }

  // Save complete user data
  static Future<void> saveUserData({
    required String token,
    required int userId,
    required String userName,
    required String userEmail,
  }) async {
    await saveLogin();
    await saveToken(token);
    await saveUserId(userId);
    await saveUserName(userName);
    await saveUserEmail(userEmail);
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final isLogin = await getLogin();
    final token = await getToken();
    return isLogin == true && token != null && token.isNotEmpty;
  }
}
