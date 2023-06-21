import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Article>> fetchArticles() async {
  final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=agriculture&apiKey=9b0dffc4e1c44302a504c6ecb993b517'));

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

  Article({required this.title, required this.author, required this.description, required this.url, required this.urlToImage, required this.publishedAt});

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