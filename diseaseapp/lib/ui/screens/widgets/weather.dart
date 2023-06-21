import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: FutureBuilder(
        future: getWeatherbitWidget(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return HtmlWidget(snapshot.data.toString());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ),
  ));
}

Future<String> getWeatherbitWidget() async {
  String apiKey = 'c376723d8a9f4e45b8d187c5a116f88a';
  String url =
      'https://weatherbit.io/widgets/current/weather-embed?lang=en&location=auto-full&theme=dark&api_key=$apiKey';
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}