import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasere/Screen/Update_Form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Comment_Screen extends StatefulWidget {
  const Comment_Screen({super.key});

  @override
  State<Comment_Screen> createState() => _Comment_ScreenState();
}

class _Comment_ScreenState extends State<Comment_Screen> {
  int screenIndex = 0;

  //------ หน้าจอแต่ละหน้า ------
  final mobileScreens = [
    home(),
    search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text('Comment',
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
        //------ เรียกหน้าจอแต่ละหน้าตาม Index ------
        body: mobileScreens[screenIndex]);
  }
}

//------------- Home page -------------
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  CollectionReference CommentCollection =
      FirebaseFirestore.instance.collection('Comment');

  int screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: CommentCollection.snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              padding: EdgeInsets.all(8.0), // ✅ เพิ่ม Padding รอบๆ ListView
              itemBuilder: ((context, index) {
                var commentIndex = snapshot.data!.docs[index];
                int rating = commentIndex['rating'] ?? 0;
                return Slidable(
                  // ✅ **ปัดซ้ายเพื่อแชร์**
                  startActionPane: ActionPane(
                    motion: StretchMotion(), // ✅ ให้สไลด์ดูนุ่มนวล
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Colors.green,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                    ],
                  ),

                  // ✅ **ปัดขวาเพื่อแก้ไข/ลบ**
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      // 🖊 **ปุ่ม Edit**
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Update_Form(),
                              settings: RouteSettings(arguments: commentIndex),
                            ),
                          );
                        },
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),

                      // ❌ **ปุ่ม Delete**
                      SlidableAction(
                        onPressed: (context) {
                          CommentCollection.doc(commentIndex.id).delete();
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),

                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 **ชื่อหัวข้อของคอมเมนต์**
                          Text(
                            commentIndex['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),

                          // 🔹 **เนื้อหาของคอมเมนต์**
                          Text(
                            commentIndex['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),

                          SizedBox(height: 10),

                          // 🔹 **แสดงดาว**
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                Icons.star,
                                color: starIndex < rating
                                    ? Colors.amber
                                    : Colors.grey,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(), // ✅ แสดง Loading ขณะดึงข้อมูล
            );
          }
        }),
      ),
    );
  }
}

//------------- Search page -------------
class search extends StatelessWidget {
  const search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Search')],
        ),
      ),
    );
  }
}
