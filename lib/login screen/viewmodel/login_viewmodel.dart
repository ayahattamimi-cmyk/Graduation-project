import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web2/login%20screen/data/AuthService.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService;

  LoginViewModel(this._authService);

  bool isLoading = false;

  // --- تسجيل الدخول ---
  Future<User?> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        bool success = await _authService.loginToLaravel();
        if (success)
          return result.user;
        else
          throw Exception("فشل الربط مع السيرفر الرئيسي");
      }
      return null;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- إنشاء حساب جديد (نحتاجه لإضافة المشرفين) ---
  Future<User?> signUp(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // بعد إنشاء حساب فايربيس، نكلم لارفل ليثبته عنده ويعطينا توكن
        bool success = await _authService.loginToLaravel();
        if (success) return result.user;
      }
      return null;
    } catch (e) {
      debugPrint("❌ SIGN UP ERROR: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
