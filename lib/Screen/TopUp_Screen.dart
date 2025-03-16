import 'package:flutter/material.dart';

class TopUp_Screen extends StatelessWidget {
  final String gameTitle;
  final String gameImage;
  final double rating;

  const TopUp_Screen(
      {Key? key,
      required this.gameTitle,
      required this.gameImage,
      required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$gameTitle - Top Up")),
      body: Column(
        children: [
          Image.asset(gameImage,
              width: double.infinity, height: 200, fit: BoxFit.cover),
          SizedBox(height: 10),
          Text(gameTitle,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 18),
              Text("$rating", style: TextStyle(fontSize: 18)),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text("Buy Now"))
        ],
      ),
    );
  }
}
