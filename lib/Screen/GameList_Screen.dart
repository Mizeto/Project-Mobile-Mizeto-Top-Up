import 'package:flutter/material.dart';

class GameListScreen extends StatelessWidget {
  final String title;

  const GameListScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> games = [
      {'title': 'Genshin Impact', 'image': 'assets/images/GenshinIP.png'},
      {'title': 'Honkai Star Rail', 'image': 'assets/images/HonkaiSR.png'},
      {'title': 'Zenlees Zone Zero', 'image': 'assets/images/Zenless.png'},
      {'title': 'Honkai Impact 3rd', 'image': 'assets/images/HonkaiIP.png'},
      {'title': 'Arena of Valor', 'image': 'assets/images/ROV.png'},
      {'title': 'Pubg', 'image': 'assets/images/Pubg.png'},
      {'title': 'Ragnarok M : Classic', 'image': 'assets/images/ROM.png'},
      {'title': 'Clash of Clans', 'image': 'assets/images/Clash.png'},
      {'title': 'EA Sports FC', 'image': 'assets/images/FIFA.png'},
      {'title': 'Mobile Legends', 'image': 'assets/images/Mobile.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ).createShader(Rect.fromLTWH(0, 0, 200, 70)))),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                games[index]['title']!,
                style: TextStyle(fontSize: 16),
              ),
              leading: Image.asset(games[index]['image']!),
            ),
          );
        },
      ),
    );
  }
}
