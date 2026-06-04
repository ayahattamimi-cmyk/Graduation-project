import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/network/api_service.dart';
import 'package:dio/dio.dart';
import 'package:web2/core/services/shared_pref.dart';

class AuthService {
  final ApiService _apiService;
  AuthService(this._apiService);

  Future<bool> loginToLaravel() async {
    try {
      // 1. الحصول على التوكن من فايربيس
      User? user = FirebaseAuth.instance.currentUser;
      String? firebaseToken = await user?.getIdToken();

      if (firebaseToken == null) return false;

      // 2. إرسال التوكن إلى لارفل باستخدام FormData
      FormData formData = FormData.fromMap({'idToken': firebaseToken});

      final response = await _apiService.post('login', data: formData);

      if (response.statusCode == 200) {
        String laravelToken = response.data['data']['token'];
        await SharedPrefsService.saveToken(laravelToken);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("❌ Login Error: $e");
      return false;
    }
  }
}
