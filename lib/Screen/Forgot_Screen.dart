import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot_Screen extends StatefulWidget {
  const Forgot_Screen({super.key});

  @override
  _Forgot_ScreenState createState() => _Forgot_ScreenState();
}

class _Forgot_ScreenState extends State<Forgot_Screen> {
  final emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to your email.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme; // ✅ รองรับ Dark Mode

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ **คำอธิบายการรีเซ็ตรหัสผ่าน**
              Text(
                "Enter your email and we will send you a password reset link.",
                style: TextStyle(fontSize: 16, color: theme.onSurface),
              ),
              SizedBox(height: 20),

              // ✅ **Email Input**
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 30),

              // ✅ **Reset Password Button**
              Center(
                child: ElevatedButton(
                  onPressed: resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    backgroundColor: theme.primary,
                    foregroundColor: theme.onPrimary,
                  ),
                  child: Text("Reset Password"),
                ),
              ),

              SizedBox(height: 20),

              // ✅ **Divider และปุ่มกลับไปหน้า Login**
              Row(
                children: [
                  Expanded(
                      child: Divider(color: theme.onSurface, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Back to login"),
                  ),
                  Expanded(
                      child: Divider(color: theme.onSurface, thickness: 1)),
                ],
              ),
              SizedBox(height: 20),

              // ✅ **Back to Login Button**
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Return to Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
