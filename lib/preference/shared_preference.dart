import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _lastLoginKey = 'last_login';

  // ============ TOKEN METHODS ============ //

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('✅ Token saved');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print('✅ Token removed');
  }

  // ============ USER DATA METHODS ============ //

  static Future<void> saveUser(String userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userJson);
    print('✅ User data saved');
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    print('✅ User data removed');
  }

  // ============ REMEMBER ME CREDENTIALS ============ //

  static Future<void> saveCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      await prefs.setString(_savedEmailKey, email);
      await prefs.setString(_savedPasswordKey, password);
    } else {
      await prefs.remove(_savedEmailKey);
      await prefs.remove(_savedPasswordKey);
    }

    await prefs.setBool(_rememberMeKey, rememberMe);

    // Simpan waktu login terakhir
    await prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());

    print('✅ Credentials saved (remember me: $rememberMe)');
  }

  static Future<Map<String, dynamic>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    final email = prefs.getString(_savedEmailKey);
    final password = prefs.getString(_savedPasswordKey);
    final lastLogin = prefs.getString(_lastLoginKey);

    return {
      'rememberMe': rememberMe,
      'email': email,
      'password': password,
      'lastLogin': lastLogin != null ? DateTime.parse(lastLogin) : null,
    };
  }

  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedPasswordKey);
    await prefs.remove(_rememberMeKey);
    print('✅ Credentials cleared');
  }

  // ============ LAST LOGIN INFO ============ //

  static Future<void> updateLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getString(_lastLoginKey);
    return lastLogin != null ? DateTime.parse(lastLogin) : null;
  }

  // ============ CLEAR ALL DATA (ONLY ON LOGOUT) ============ //

  static Future<void> clearAllOnLogout() async {
    final prefs = await SharedPreferences.getInstance();

    // Hanya hapus token dan user data, tapi pertahankan credentials
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_lastLoginKey);

    print('✅ Cleared session data on logout (credentials preserved)');
  }

  // ============ COMPLETE CLEAR (FOR DEBUG) ============ //

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('✅ All preferences cleared');
  }
}
