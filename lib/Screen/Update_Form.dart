import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Update_Form extends StatefulWidget {
  @override
  State<Update_Form> createState() => _Update_FormState();
}

class _Update_FormState extends State<Update_Form> {
  CollectionReference postCollection =
      FirebaseFirestore.instance.collection('Comment');

  @override
  Widget build(BuildContext context) {
    final postData = ModalRoute.of(context)!.settings.arguments as dynamic;

    final titleController = TextEditingController(text: postData['title']);
    final descriptionController =
        TextEditingController(text: postData['description']);
    int rating = postData['rating'] ?? 0; // ✅ ดึงค่าดาวจาก Firestore

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Center(
          child: Text(
            'Update Comment',
            style: TextStyle(
              fontFamily: 'gamer1',
              fontSize: 35,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ).createShader(Rect.fromLTWH(0, 0, 300, 70)),
            ),
          ),
        ),
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
                    fontFamily: 'gamer1',
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 20),

                // 🔹 **ช่องกรอกหัวข้อโพสต์**
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Edit title',
                    icon: Icon(Icons.title),
                  ),
                ),
                SizedBox(height: 10),

                // 🔹 **ช่องกรอกเนื้อหาของโพสต์**
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Edit content',
                    icon: Icon(Icons.description),
                  ),
                ),
                SizedBox(height: 20),

                // 🔹 **ระบบให้ดาว**
                Text(
                  'Rating:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),

                // 🔹 **ปุ่มเพิ่มดาว และลดดาว**
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          if (rating > 0) {
                            rating--;
                          }
                        });
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
                        setState(() {
                          if (rating < 5) {
                            rating++;
                          }
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // 🔹 **ปุ่มอัปเดตข้อมูล**
                ElevatedButton(
                  onPressed: () {
                    postCollection.doc(postData.id).update({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'rating': rating, // ✅ บันทึกค่าดาวลง Firestore
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
