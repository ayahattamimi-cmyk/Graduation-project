import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web2/login%20screen/data/AuthService.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService;

  /// ينشئ [LoginViewModel] مع [AuthService] المحدد.
  LoginViewModel(this._authService);

  bool isLoading = false;

  /// يسجّل الدخول بـ [email] و [password] عبر Firebase، ثم يُوثّق مع خلفية Laravel.
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

  /// ينشئ مستخدم Firebase جديد بـ [email] و [password]، ثم يُوثّق مع Laravel.
  Future<User?> signUp(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        bool success = await _authService.loginToLaravel();
        if (success) return result.user;
      }
      return null;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// يسجّل خروج المستخدم الحالي من Firebase.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
