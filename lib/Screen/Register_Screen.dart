import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Home_Screen.dart';
import 'Login_Screen.dart';

class Register_Screen extends StatefulWidget {
  const Register_Screen({super.key});

  @override
  _Register_ScreenState createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 🔹 **ฟังก์ชันแสดงข้อความแจ้งเตือน**
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> signUserUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // 🔹 **เช็คว่ารหัสผ่านตรงกันหรือไม่**
    if (password != confirmPassword) {
      showErrorMessage("รหัสผ่านไม่ตรงกัน");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home_Screen()));
    } on FirebaseAuthException catch (e) {
      showErrorMessage("เกิดข้อผิดพลาด: ${e.message}");
    }
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
              SizedBox(height: 20),

              // ✅ **Already have an account? Login**
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login_Screen()));
                      },
                      child: Text('Login now'),
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
