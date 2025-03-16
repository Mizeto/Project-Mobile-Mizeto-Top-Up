import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screen/GameList_Screen.dart';
import 'Screen/TopUp_Screen.dart';
import 'Screen/Authen_Screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Top-up App',
      home: MainScreen(), // หน้าตรวจสอบการล็อกอิน
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
          ),
        ],
        title: Text(
          'Mizeto - Top Up',
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel for promotions
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
            // Recently Top Up section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recently Top Up',
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
                            builder: (context) =>
                                GameListScreen(title: 'Recently Top Up Games')),
                      );
                    },
                    child: Text('See All',
                        style: TextStyle(color: Colors.blueAccent)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 128,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GameCard(
                      imagePath: 'assets/images/GenshinIP.png',
                      title: 'Genshin Impact'),
                  GameCard(
                      imagePath: 'assets/images/HonkaiSR.png',
                      title: 'Honkai Star Rail'),
                  GameCard(
                      imagePath: 'assets/images/Pubg.png',
                      title: 'PUBG Mobile'),
                  GameCard(
                      imagePath: 'assets/images/ROV.png',
                      title: 'Arena of Valor'),
                ],
              ),
            ),
            // Popular Game section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Games',
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
                            builder: (context) =>
                                GameListScreen(title: 'Popular Games')),
                      );
                    },
                    child: Text('See All',
                        style: TextStyle(color: Colors.blueAccent)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 128,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GameCard(
                      imagePath: 'assets/images/HonkaiSR.png',
                      title: 'Honkai Star Rail'),
                  GameCard(
                      imagePath: 'assets/images/GenshinIP.png',
                      title: 'Genshin Impact'),
                  GameCard(
                      imagePath: 'assets/images/HonkaiIP.png',
                      title: 'Honkai Impact 3rd'),
                  GameCard(
                      imagePath: 'assets/images/Zenless.png',
                      title: 'Zenlees Zone Zero'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: user == null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Authen_Screen()),
                );
              },
              label: Text('Login', style: TextStyle(color: Colors.white)),
              backgroundColor: Color.fromRGBO(40, 84, 48, 1),
            )
          : null, // If user is logged in, no login button
    );
  }
}

class GameCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const GameCard({Key? key, required this.imagePath, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (FirebaseAuth.instance.currentUser == null) {
                // If not logged in, show message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Please log in to access this feature')),
                );
              } else {
                // Navigate to game top-up page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopUp_Screen(
                      gameTitle: title,
                      gameImage: imagePath,
                      rating: 4.7,
                    ),
                  ),
                );
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(title,
              style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
