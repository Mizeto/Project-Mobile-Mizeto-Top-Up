import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasere/Screen/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'Home_Screen.dart';

class Authen_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home_Screen(); // ถ้าผู้ใช้ล็อกอินแล้ว
          } else {
            return Login_Screen(); // ถ้ายังไม่ได้ล็อกอิน
          }
        },
      ),
    );
  }
}
