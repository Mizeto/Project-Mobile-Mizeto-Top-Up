import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasere/Screen/Forgot_Screen.dart';
import 'package:firebasere/Screen/Register_Screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'Home_Screen.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 🔹 **ฟังก์ชันแสดงข้อความแจ้งเตือน**
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
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

  Future<void> signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home_Screen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorMessage("ไม่มีบัญชีนี้อยู่ในระบบ");
      } else if (e.code == 'wrong-password') {
        showErrorMessage("รหัสผ่านไม่ถูกต้อง");
      } else {
        showErrorMessage("เกิดข้อผิดพลาด: ${e.message}");
      }
    }
  }

  Widget _buildNavButton(IconData icon, int index, Widget page, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            if (!context.mounted)
              return; // ป้องกันการเรียก Navigator.push ถ้า context ไม่อยู่แล้ว
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text(
                "Login to Your Account",
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Forgot_Screen()),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text("Remember me", style: TextStyle(color: Colors.black)),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: signUserIn,
                child: Text("Login"),
              ),
              SizedBox(height: 20),
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?',
                        style: TextStyle(color: Colors.black)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Register_Screen()),
                        );
                      },
                      child: Text('Register now'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
