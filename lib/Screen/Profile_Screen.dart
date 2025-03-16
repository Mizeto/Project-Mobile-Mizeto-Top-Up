import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasere/Screen/EditProfile_Screen.dart';
import 'package:firebasere/Screen/Login_Screen.dart';
import 'package:flutter/material.dart';

class Profile_Screen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  // ✅ แสดง Dialog ยืนยันก่อน Logout
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Log Out",
          style: TextStyle(
            fontFamily: 'gamer1',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        content: Text("Are you sure you want to log out?"),
        actions: [
          // ❌ ปุ่ม Cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          // ✅ ปุ่ม Logout
          TextButton(
            onPressed: () => signOutUser(context),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              "Log Out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ฟังก์ชันออกจากระบบ
  Future<void> signOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login_Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme; // รองรับ Dark Mode

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'gamer1',
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        actions: [
          // ✅ **ปุ่มแก้ไขโปรไฟล์**
          IconButton(
            icon: Icon(Icons.edit, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile_Screen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ **Avatar ของผู้ใช้**
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                user?.photoURL ?? 'https://example.com/default_avatar.png',
              ),
            ),
            SizedBox(height: 10),

            // ✅ **แสดงชื่อผู้ใช้**
            Text(
              user?.displayName ?? "No Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            // ✅ **แสดงอีเมล**
            Text(
              user?.email ?? "No Email",
              style: TextStyle(fontSize: 16, color: theme.onSurface),
            ),
            SizedBox(height: 20),

            // ✅ **ปุ่ม Logout พร้อมแสดง Dialog**
            ElevatedButton(
              onPressed: () => showLogoutDialog(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}
