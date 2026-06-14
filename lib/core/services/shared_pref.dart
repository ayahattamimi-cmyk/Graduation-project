import 'package:shared_preferences/shared_preferences.dart';

/// يدير حفظ رمز التوثيق (token) عبر التخزين المحلي (shared preferences).
class SharedPrefsService {
  static const String _tokenKey = 'laravel_token';

  /// يحفظ رمز التوثيق [token] المحدد في التخزين المحلي.
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// يسترجع رمز التوثيق المخزن، أو null إذا لم يكن موجودًا.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// يزيل رمز التوثيق المخزن (يُستخدم عند تسجيل الخروج).
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// يعيد true إذا كان هناك رمز توثيق غير فارغ مخزن حاليًا.
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
