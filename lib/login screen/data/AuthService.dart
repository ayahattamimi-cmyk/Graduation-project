import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web2/core/services/shared_pref.dart';

class AuthService {
  final Dio _dio;
  AuthService(this._dio);

  Future<bool> loginToLaravel() async {
    try {
      // 1. الحصول على التوكن من فايربيس
      User? user = FirebaseAuth.instance.currentUser;
      String? firebaseToken = await user?.getIdToken();

      if (firebaseToken == null) return false;

      // 2. إرسال التوكن إلى لارفل (كما في Postman) باستخدام FormData
      FormData formData = FormData.fromMap({
        'idToken': firebaseToken,
        // 'role': 'admins', // أضيفيها إذا كان السيرفر يتطلب تحديد الدور هنا
      });

      final response = await _dio.post('login', data: formData);

      if (response.statusCode == 200) {
        String laravelToken = response.data['data']['token'];
        await SharedPrefsService.saveToken(laravelToken); 
        print("💾 تم حفظ التوكن بنجاح في الذاكرة: $laravelToken");
        return true;
      }

      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }
}
