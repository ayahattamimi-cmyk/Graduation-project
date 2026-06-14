import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/network/api_service.dart';
import 'package:dio/dio.dart';
import 'package:web2/core/services/shared_pref.dart';

class AuthService {
  final ApiService _apiService;

  /// ينشئ [AuthService] مع [ApiService] المحدد.
  AuthService(this._apiService);

  /// يُوثّق مع خلفية Laravel باستخدام رمز مستخدم Firebase الحالي.
  /// يعيد true عند النجاح.
  Future<bool> loginToLaravel() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? firebaseToken = await user?.getIdToken();

      if (firebaseToken == null) return false;

      FormData formData = FormData.fromMap({'idToken': firebaseToken});

      final response = await _apiService.post('login', data: formData);

      if (response.statusCode == 200) {
        String laravelToken = response.data['data']['token'];
        await SharedPrefsService.saveToken(laravelToken);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
