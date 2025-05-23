import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login/login.dart';

class Utils{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      // Handle logout error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }

  String? getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid; // Return the UID if the user is signed in
    } else {
      print('No user is currently signed in.');
      return null; // Return null if no user is signed in
    }
  }

  Future<bool> checkIfUserExists() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('No user is currently signed in.');
        return false;
      }

      String uid = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        print('User already exists.');
        return true; // Existing user
      } else {
        print('New user detected.');
        return false; // New user
      }
    } catch (e) {
      print('Error checking user existence: $e');
      rethrow;
    }
  }


}