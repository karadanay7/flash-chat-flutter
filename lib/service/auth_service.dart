import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  Future signInAnonymous() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      print(result.user!.uid);
      return result.user;
    } catch (e) {
      print('Anon error $e');
      return null;
    }
  }

  Future forgetPassword(String email) async {
    try {
      final result = await firebaseAuth.sendPasswordResetEmail(email: email);
      print("check you email inbox");
    } catch (e) {
      print("Failed to send password reset email: $e");
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
res = 'success';
    } on FirebaseAuthException catch  (e) {

      if( e.code == "INVALID_LOGIN_CREDENTIALS") {
        res = "Wrong email or password";
      } else if  ( e.code == 'user-not-found') {
        res = "user not found";
      } else {
        res = e.code;
      }

    }
    return res;

  }
}
