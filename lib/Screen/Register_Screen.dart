import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'Home_Screen.dart';
import 'Login_Screen.dart';

class Register_Screen extends StatefulWidget {
  const Register_Screen({super.key});

  @override
  _Register_ScreenState createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  bool _obscurePassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> signUserUp() async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home_Screen()),
        );
      } else {
        print("Passwords do not match");
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // ✅ ป้องกัน Overflow
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.1), // ✅ ปรับให้เหมาะกับหน้าจอ
              Text(
                "Register Your Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                ),
              ),
              SizedBox(height: 20),

              // ✅ **Email Field**
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 20),

              // ✅ **Password Field**
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 20),

              // ✅ **Confirm Password Field**
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirm Password"),
              ),
              SizedBox(height: 40),

              // ✅ **Register Button**
              ElevatedButton(
                onPressed: signUserUp,
                child: Text("Register"),
              ),
              SizedBox(height: 40),

              // ✅ **Divider: "Or continue with"**
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.black, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Or continue with",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.black, thickness: 1)),
                ],
              ),
              SizedBox(height: 20),

              // ✅ **Social Media Login**
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.g_mobiledata_rounded,
                        size: 40, color: Colors.black),
                    onPressed: () {
                      signInWithGoogle();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.facebook, size: 40, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.apple, size: 40, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 20),

              // ✅ **Already have an account? Login**
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',
                        style: TextStyle(color: Colors.black)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login_Screen()),
                        );
                      },
                      child: Text('Login now'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // ✅ ป้องกันปุ่มติดขอบล่างของหน้าจอ
            ],
          ),
        ),
      ),
    );
  }
}
