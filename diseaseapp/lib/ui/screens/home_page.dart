import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class WeatherbitWidget extends StatefulWidget {
  WeatherbitWidget({Key? key}) : super(key: key);

  String apiKey = 'c376723d8a9f4e45b8d187c5a116f88a';
  String url = 'https://api.weatherbit.io/v2.0/current?';

  String temperature = '';
  String description = '';
  String icon = '';
  bool isloading = true;

  @override
  _WeatherbitWidgetState createState() => _WeatherbitWidgetState();
}

class _WeatherbitWidgetState extends State<WeatherbitWidget> {
  Future<void> getWeatherData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double latitude = position.latitude;
    double longitude = position.longitude;

    String apiUrl =
        '${widget.url}&lat=$latitude&lon=$longitude&key=${widget.apiKey}&units=metric';

    http.Response response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        widget.temperature = data['data'][0]['temp'].toString() + '°C';
        widget.description = data['data'][0]['weather']['description'];
        widget.icon = data['data'][0]['weather']['icon'];
        widget.isloading = false;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 50), getWeatherData);
    return Scaffold(
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 40,
          ),
          Container(
            width: 300,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 187, 225, 244),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.temperature,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.0),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 6.0),
                widget.isloading
                    ? Center(child: CircularProgressIndicator())
                    : Image.network(
                        'https://www.weatherbit.io/static/img/icons/${widget.icon}.png',
                        height: 50.0,
                        width: 50.0,
                      ),
                SizedBox(height: 6.0),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Future<List<Article>> fetchArticles() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/everything?q=agriculture&apiKey=9b0dffc4e1c44302a504c6ecb993b517'));

  if (response.statusCode == 200) {
    List<dynamic> articlesJson = jsonDecode(response.body)['articles'];
    return articlesJson.map((article) => Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

class Article {
  final String title;
  final String author;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;

  Article(
      {required this.title,
      required this.author,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
    );
  }
}

Widget news() {
  return SizedBox(
    height: 30,
    width: 30,
    child: FutureBuilder<List<Article>>(
      future: fetchArticles(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].title),
                subtitle: Text(snapshot.data![index].description),
                leading: Image.network(snapshot.data![index].urlToImage),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    ),
  );
}
