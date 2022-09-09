import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  Future<String?> userLogin(String email, String password, context) async {
    // Login user via Firebase database
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (FirebaseAuth.instance.currentUser != null) {
        final token = await FirebaseAuth.instance.currentUser!.getIdToken();
        return token;
      } else {
        showErrorMessage('Error logging in.', context);
        throw "User could not be logged in.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        // If the user does not exist in the database
        case 'user-not-found':
          return e.code;
        // If the user entered the wrong credentials
        case 'wrong-password':
          return e.code;
        // If the login process failed
        default:
          showErrorMessage('Error logging in.', context);
          return null;
      }
    }
  }

  Future<String?> userSignUp(String email, String password, context) async {
    // Sign user up via Firebase database
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (FirebaseAuth.instance.currentUser != null) {
        final token = await FirebaseAuth.instance.currentUser!.getIdToken();
        return token;
      } else {
        // FirebaseAuth.instance.currentUser!.delete();
        showErrorMessage('Error signing up.', context);
        throw "New user couldn't be registered";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        // If the user already exists
        case 'email-already-in-use':
          return e.code;
        // If the sign up process failed
        default:
          showErrorMessage('Error signing up.', context);
          return null;
      }
    }
  }

  Future<String?> resetUserPassword(String email, context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return 'success';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        // If the user does not exist in the database
        case 'user-not-found':
          return e.code;
        // If the password reset process failed
        default:
          showErrorMessage(e.code, context);
          return null;
      }
    }
  }
}

// A universal error message should any http calls return an error status code
void showErrorMessage(String errorMessage, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.all(20),
      content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          '$errorMessage Please try again.',
          style: const TextStyle(
              color: Colors.black, fontFamily: 'OpenSans', fontSize: 15),
        ),
      ]),
    ),
  );
}
