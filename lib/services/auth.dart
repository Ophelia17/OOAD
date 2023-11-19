import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:enono/services/firestore_db.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<dynamic> loginEmailPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    dynamic checkNew = await getUserLocationAndName(auth.currentUser!.uid);
    if (checkNew == 'registration_pending'){
      await auth.currentUser!.delete();
      //start registration flow, lead to registration screen
      return 'registration_pending';
    }
    return auth.currentUser!.uid;
  } on FirebaseAuthException catch (e) {
    return e.toString();
  }
}

Future<dynamic> logOut(bool logOutGoogle)async{
 try {
  await FirebaseAuth.instance.signOut();
  if (logOutGoogle){
    await GoogleSignIn().signOut();
  }
  return true;
 } on FirebaseAuthException catch (e) {
  return e.toString();
 }
}

Future<dynamic> signInWithGoogle() async {
  try {
    //var googleAuthProvider = new FirebaseAuth.instance.GoogleAuthProvider();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // print(credential);

    // Once signed in, return the UserCredential
    await auth.signInWithCredential(credential);
    dynamic checkNew = await getUserLocationAndName(auth.currentUser!.uid);
    if (checkNew == 'registration_pending'){
      //start registration flow, lead to registration screen
      print("registration is pending");
      await logOut(true);
      await auth.currentUser!.delete();
      return 'registration_pending';
    }
    print("registration is not pending");
    return auth.currentUser!.uid;
  } on Exception {
    return false;
  }
}