import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  Future<void> signUp(String email, String password) async {

    try {

      isLoading = true;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } catch (e) {

      debugPrint(e.toString());

    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {

    try {

      isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    } catch (e) {

      debugPrint(e.toString());

    }

    isLoading = false;
    notifyListeners();
  }
}