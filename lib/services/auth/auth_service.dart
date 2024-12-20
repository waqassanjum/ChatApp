import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/Pages/login_page.dart';

// import '../../Pages/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

class AuthService {
  //instance of Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //save user info if it is not already exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up
  Future<void> signUpWithEmailPassword(
    BuildContext context,
    String email,
    password,
  ) async {
    try {
      //user create
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //save user info in a separated doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          showCloseIcon: true,

          content: Text('User registration successful'),
          duration: Duration(seconds: 3), // Optional: Set duration
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      throw ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,

          content: Text(e.toString()),
          duration: const Duration(seconds: 3), // Optional: Set duration
        ),
      );
    }
  }

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //errors
}
