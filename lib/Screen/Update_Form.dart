import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Update_Form extends StatefulWidget {
  @override
  State<Update_Form> createState() => _Update_FormState();
}

class _Update_FormState extends State<Update_Form> {
  CollectionReference postCollection =
      FirebaseFirestore.instance.collection('Comment');

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late int rating;
  bool isLoading = true; // ✅ ใช้เพื่อแสดงตัวโหลดก่อนแสดงข้อมูล

  @override
  void initState() {
    super.initState();
    // 🔹 ใช้ WidgetsBinding เพื่อดึงข้อมูลจาก `ModalRoute` ให้เสร็จก่อน
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postData = ModalRoute.of(context)!.settings.arguments as dynamic;

      if (postData != null) {
        setState(() {
          titleController =
              TextEditingController(text: postData['title'] ?? '');
          descriptionController =
              TextEditingController(text: postData['description'] ?? '');
          rating = postData['rating'] ?? 0;
          isLoading = false; // ✅ โหลดข้อมูลเสร็จแล้ว
        });
      }
    });
  }

  void updateRating(int change) {
    setState(() {
      rating = (rating + change).clamp(0, 5); // ✅ จำกัดค่าให้อยู่ในช่วง 0-5
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // ✅ แสดงตัวโหลดก่อน
          : SingleChildScrollView(
              child: Center(
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Please comment politely!!!',
                        style: TextStyle(
                            fontFamily: 'gamer1',
                            fontSize: 25,
                            color: Colors.red),
                      ),
                      SizedBox(height: 20),

                      // 🔹 **ช่องกรอกหัวข้อโพสต์**
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'Change a name game',
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
                            hintText: 'Change your comment',
                            icon: Icon(Icons.rate_review),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // 🔹 **ระบบให้ดาว**
                      Text(
                        'Rating:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),

                      // 🔹 **ปุ่มเพิ่มดาว และลดดาว**
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => updateRating(-1),
                          ),

                          // **แสดงดาว**
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color:
                                    index < rating ? Colors.amber : Colors.grey,
                              );
                            }),
                          ),

                          IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () => updateRating(1),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // 🔹 **ปุ่มอัปเดตข้อมูล**
                      ElevatedButton(
                        onPressed: () {
                          final postData = ModalRoute.of(context)!
                              .settings
                              .arguments as dynamic;
                          postCollection.doc(postData.id).update({
                            'title': titleController.text.trim(),
                            'description': descriptionController.text.trim(),
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
