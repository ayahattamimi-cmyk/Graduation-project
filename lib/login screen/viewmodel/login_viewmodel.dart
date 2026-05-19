import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  Future<User?> signUp(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      print(" SIGN UP ERROR: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      print(" SIGN IN ERROR: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}