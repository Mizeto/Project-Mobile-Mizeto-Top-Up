import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile_Screen extends StatefulWidget {
  @override
  _EditProfile_ScreenState createState() => _EditProfile_ScreenState();
}

class _EditProfile_ScreenState extends State<EditProfile_Screen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController photoURLController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = user?.displayName ?? "";
    photoURLController.text = user?.photoURL ?? "";
  }

  Future<void> updateProfile() async {
    try {
      await user?.updateDisplayName(nameController.text);
      await user?.updatePhotoURL(photoURLController.text);
      await user?.reload();

      if (mounted) {
        // เช็คว่า widget ยังอยู่ใน widget tree ก่อนทำการ update UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile Updated Successfully!")),
        );
        Navigator.pop(context); // ✅ กลับไปหน้า Profile
      }
    } catch (e) {
      if (mounted) {
        // เช็คว่า widget ยังอยู่ใน widget tree ก่อนทำการ update UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme; // ✅ รองรับ Dark Mode

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            // ✅ **Avatar แสดงตัวอย่างรูปโปรไฟล์**
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photoURLController.text),
            ),
            SizedBox(height: 20),

            // ✅ **TextField สำหรับแก้ไขชื่อ**
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // ✅ **TextField สำหรับแก้ไข URL รูปโปรไฟล์**
            TextField(
              controller: photoURLController,
              decoration: InputDecoration(
                labelText: "Photo URL",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {}); // ✅ อัปเดตรูปเมื่อเปลี่ยน URL
              },
            ),
            SizedBox(height: 30),

            // ✅ **ปุ่มบันทึกการแก้ไข**
            ElevatedButton(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                backgroundColor: theme.primary,
                foregroundColor: theme.onPrimary,
              ),
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
