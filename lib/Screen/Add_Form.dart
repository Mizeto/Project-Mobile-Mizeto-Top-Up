import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Add_Form extends StatefulWidget {
  @override
  State<Add_Form> createState() => _Add_FormState();
}

class _Add_FormState extends State<Add_Form> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int rating = 0; // ✅ ค่าเริ่มต้นของ rating

  CollectionReference CommentCollection =
      FirebaseFirestore.instance.collection('Comment');

  // 🔹 **แสดง Snackbar เมื่อเกิดข้อผิดพลาด**
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void submitComment() {
    if (titleController.text.trim().isEmpty) {
      showErrorMessage("กรุณากรอกชื่อเกมก่อนโพสต์");
      return;
    }

    CommentCollection.add({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'rating': rating, // ✅ บันทึกค่าดาวลง Firestore
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text('Add Comment',
            style: TextStyle(
              fontFamily: 'gamer1',
              fontSize: 35,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
            )),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Please comment politely!!!',
                  style: TextStyle(
                      fontFamily: 'gamer1', fontSize: 25, color: Colors.red),
                ),
                SizedBox(height: 20),

                // 🔹 **ช่องกรอกหัวข้อโพสต์**
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Add a name game',
                      icon: Icon(Icons.videogame_asset),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // 🔹 **ช่องกรอกเนื้อหาของโพสต์**
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Start a new comment',
                      icon: Icon(Icons.rate_review),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // 🔹 **ระบบให้ดาว**
                Text(
                  'Rating:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),

                // 🔹 **เพิ่มดาว และ ลดดาว**
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        if (rating > 0) {
                          setState(() {
                            rating--;
                          });
                        }
                      },
                    ),

                    // **แสดงดาว**
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          color: index < rating ? Colors.amber : Colors.grey,
                        );
                      }),
                    ),

                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () {
                        if (rating < 5) {
                          setState(() {
                            rating++;
                          });
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // 🔹 **ปุ่มโพสต์**
                ElevatedButton(
                  onPressed: submitComment,
                  child: Text('Enter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
