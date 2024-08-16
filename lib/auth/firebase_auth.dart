// import 'package:chat_app/screens/home_screen.dart';
// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glitz/api/apis.dart';
import 'package:glitz/helper/dialogs.dart';
import 'package:glitz/screens/login%20Screens/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuths {
  static final googleSignIn = GoogleSignIn();
  //Sign in with Google fn
  static Future<User?> signWithGoogle(BuildContext con) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await APIs.auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      Dialogs.showSnackBar(con, 'Songthig Went Wrong (Check Internet)');
      return null;
    }
  }

  //Sign Out fn
  static signOut(BuildContext con) async {
    await APIs.auth.signOut().then((value) async {
      //? sign out in google
      await GoogleSignIn().signOut().then((value) {
        //*move to home screen
        Navigator.of(con).pop();
        //? replacing home screen with login screen
        Navigator.pushReplacement(
            con, MaterialPageRoute(builder: (_) => const LoginScreen()));
      });
    });
    // await GoogleSignIn().signOut();
  }
}
