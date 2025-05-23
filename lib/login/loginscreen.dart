import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/utils/loadingdialog.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Home/seatmapscreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> signInWithGoogle() async {
    try {
      print('🔄 Signing out previous sessions...');
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      print('🔐 Showing loading dialog...');
      if (!mounted) return;
      //LoadingDialog.show(context, message: 'Signing User.');

      print('📲 Starting Google Sign-In...');
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print('❌ User cancelled Google Sign-In.');
        //if (mounted) LoadingDialog.dismiss(context);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('✅ Google Auth successful. Signing in with Firebase...');
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null || !user.email!.endsWith('@klu.ac.in')) {
        print('❌ Email is not a valid @klu.ac.in email: ${user?.email}');
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        //if (mounted) LoadingDialog.dismiss(context);

        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Invalid Email"),
              content: const Text("Only @klu.ac.in emails are allowed."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
        return;
      }

      final uid = user.uid;
      final email = user.email!;
      final regNo = email.split('@')[0];

      print('📝 Saving user data to Firestore...');
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': user.displayName ?? '',
        'email': email,
        'mobileNumber': user.phoneNumber ?? '',
        'gender': '',
        'regNo': regNo,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Sign-In and data save successful. Navigating to SeatMapScreen...');
      if (mounted) {
        //LoadingDialog.dismiss(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeatMapScreen(bookedSeats: [20])),
        );
      }
    } catch (e) {
      print('❌ Exception during sign-in: $e');
      if (mounted) {
        //LoadingDialog.dismiss(context);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Sign-In Failed"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Welcome to University',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Sign in with your university account',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 250,
                height: 60,
                child: SignInButton(
                  Buttons.google,
                  text: "Sign in with Google",
                  onPressed: () async {
                    await signInWithGoogle();
                  },
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
