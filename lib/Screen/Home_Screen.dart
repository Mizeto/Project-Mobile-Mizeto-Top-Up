import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasere/Screen/Add_Form.dart';
import 'package:firebasere/Screen/Comment_Screen.dart';
import 'package:firebasere/Screen/GameList_Screen.dart';
import 'package:firebasere/Screen/TopUp_Screen.dart';
import 'package:flutter/material.dart';
import 'Profile_Screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home_Screen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home_Screen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final PageController _pageController = PageController();
  int currentPage = 0;
  Timer? _timer;
  int screenIndex = 0;

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (currentPage < 7) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      if (mounted) {
        _pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(
            'Home',
            style: TextStyle(
              fontFamily: 'gamer1',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔹 **Carousel แสดงโปรโมชั่น**
              Container(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 8,
                  onPageChanged: (index) {
                    setState(() => currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/promotion/promotion${index + 1}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// 🔹 **Indicator**
              SizedBox(height: 10),
              SmoothPageIndicator(
                controller: _pageController,
                count: 8,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.black,
                  dotColor: Colors.grey,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 2,
                ),
                onDotClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),

              /// 🔹 **Recently Top Up**
              _buildSectionHeader(
                  context, 'Recently Top Up', 'Recently Top Up Games'),

              _buildGameList([
                {
                  'title': 'Genshin Impact',
                  'image': 'assets/images/GenshinIP.png'
                },
                {
                  'title': 'Honkai Star Rail',
                  'image': 'assets/images/HonkaiSR.png'
                },
                {'title': 'PUBG Mobile', 'image': 'assets/images/Pubg.png'},
                {'title': 'Arena of Valor', 'image': 'assets/images/ROV.png'},
              ]),

              /// 🔹 **Popular Games**
              _buildSectionHeader(context, 'Popular Games', 'Popular Games'),

              _buildGameList([
                {
                  'title': 'Honkai Star Rail',
                  'image': 'assets/images/HonkaiSR.png'
                },
                {
                  'title': 'Genshin Impact',
                  'image': 'assets/images/GenshinIP.png'
                },
                {
                  'title': 'Honkai Impact 3rd',
                  'image': 'assets/images/HonkaiIP.png'
                },
                {
                  'title': 'Zenlees Zone Zero',
                  'image': 'assets/images/Zenless.png'
                },
              ]),
            ],
          ),
        ),

        /// 🔹 **Bottom Navigation Bar**
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton(Icons.home, 0, Home_Screen()),
              _buildNavButton(Icons.shopping_cart, 1, Home_Screen()),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Add_Form()));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                backgroundColor: Colors.amber,
                child: Icon(Icons.add, color: Colors.white),
              ),
              _buildNavButton(Icons.comment, 2, Comment_Screen()),
              _buildNavButton(Icons.person, 3, Profile_Screen()),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 **ฟังก์ชันสร้างแถบหัวข้อ + See All**
  Widget _buildSectionHeader(
      BuildContext context, String title, String seeAllTitle) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 70)))),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameListScreen(title: seeAllTitle)),
              );
            },
            child: Text('See All', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  /// 🔹 **ฟังก์ชันสร้างรายการเกม**
  Widget _buildGameList(List<Map<String, String>> games) {
    return SizedBox(
      height: 128,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopUp_Screen(
                    gameTitle: games[index]['title']!,
                    gameImage: games[index]['image']!,
                    rating: 4.7,
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(games[index]['image']!,
                        width: 100, height: 100, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 8),
                  Text(games[index]['title']!,
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔹 **ฟังก์ชันสร้างปุ่มใน Bottom Navigation Bar**
  Widget _buildNavButton(IconData icon, int index, Widget page) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
