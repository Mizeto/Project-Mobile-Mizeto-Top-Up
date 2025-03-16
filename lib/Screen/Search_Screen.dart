import 'package:flutter/material.dart';

// 🔎 **Delegate สำหรับการค้นหาเกม**
class GameSearch extends SearchDelegate<String> {
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

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildGameList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildGameList();
  }

  Widget _buildGameList() {
    final List<Map<String, String>> filteredGames = games
        .where((game) =>
            game['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredGames.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(filteredGames[index]['image']!, width: 50),
          title: Text(filteredGames[index]['title']!),
          onTap: () {
            close(context, filteredGames[index]['title']!);
          },
        );
      },
    );
  }
}
