import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Anime {
  final String title;
  final String param;
  final String thumbnail;
  final String uploadTime;
  final String detailUrl;

  Anime({
    required this.title,
    required this.param,
    required this.thumbnail,
    required this.uploadTime,
    required this.detailUrl,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      title: json['title'],
      param: json['param'],
      thumbnail: json['thumbnail'],
      uploadTime: json['upload_time'],
      detailUrl: json['detail_url'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimeListPage(),
    );
  }
}

class AnimeListPage extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  late List<Anime> animeList;

  @override
  void initState() {
    super.initState();
    fetchAnimeList();
  }

Future<void> fetchAnimeList() async {
  final Uri url = Uri.parse('https://animev1.bimabizz.my.id//api/anime/');
  final response = await http.get(url);
  final jsonResponse = json.decode(response.body);

  setState(() {
    animeList = (jsonResponse['data'] as List)
        .map((data) => Anime.fromJson(data))
        .toList();
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime List'),
      ),
      body: animeList == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                return ListTile(
  title: Text(animeList[index].title),
  subtitle: Text(animeList[index].uploadTime),
  leading: Image.network(
    animeList[index].thumbnail,
    errorBuilder: (context, error, stackTrace) {
      return Icon(Icons.error); // Display an error icon if the image fails to load
    },
  ),
  onTap: () {
    // Handle tap, navigate to detail page, etc.
    // You can use animeList[index].detailUrl for navigation.
  },
);

              },
            ),
    );
  }
}
