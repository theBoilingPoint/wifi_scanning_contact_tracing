import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/services/cloud_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create UserInfo obj based on User
  CustomisedUser _customisedUserFromUser(User user){
    return user != null ? CustomisedUser(user.uid, false) : null;
  }

  //auth change user stream
  //In the youtube tutorial it's Stream<User>
  Stream<CustomisedUser> get user {
    return _auth.authStateChanges()
        .map(_customisedUserFromUser);
    // .map((User user) => _customisedUserFromUser(user));
  }

  //sign in anon
  Future signInAnon() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      // original class: AuthResult
      UserCredential result = await _auth.signInAnonymously();
      // original class: FirebaseUser
      User user = result.user;
      return _customisedUserFromUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _customisedUserFromUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _customisedUserFromUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }
}