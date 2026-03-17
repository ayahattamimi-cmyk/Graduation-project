import 'package:firebase_auth/firebase_auth.dart';

class AuthData {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {

    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

}