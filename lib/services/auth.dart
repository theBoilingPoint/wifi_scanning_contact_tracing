import 'package:firebase_auth/firebase_auth.dart';

class AuthServer {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign in anon
  Future signInAnon() async {
    try {
      // original class: AuthResult
      UserCredential result = await _auth.signInAnonymously();
      // original class: FirebaseUser
      User user = result.user;
      return user;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password

  //register with email & password

  //sign out
}