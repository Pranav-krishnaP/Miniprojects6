// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       body: FutureBuilder(
//         future: getWeatherbitWidget(),
//         builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//           if (snapshot.hasData) {
//             return HtmlWidget(snapshot.data.toString());
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     ),
//   ));
// }

// Future<String> getWeatherbitWidget() async {
//   String apiKey = 'c376723d8a9f4e45b8d187c5a116f88a';
//   String url =
//       'https://weatherbit.io/widgets/current/weather-embed?lang=en&location=auto-full&theme=dark&api_key=$apiKey';
//   http.Response response = await http.get(Uri.parse(url));
//   return response.body;
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class Weather {
  String apiKey = 'c376723d8a9f4e45b8d187c5a116f88a';
  String url = 'https://api.weatherbit.io/v2.0/current?';

  String temperature = '';
  String description = '';
  String icon = '';
  bool isloading = true;

  Weather() {
    getWeatherData();
  }

  Widget weather() {
    return Container(
      width: double.infinity,
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
            temperature,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 6.0),
          isloading
              ? Center(child: CircularProgressIndicator())
              : Image.network(
                  'https://www.weatherbit.io/static/img/icons/${icon}.png',
                  height: 50.0,
                  width: 50.0,
                ),
        ],
      ),
    );
  }

  Future<List<String>> getWeatherData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double latitude = position.latitude;
    double longitude = position.longitude;

    String apiUrl =
        '${url}&lat=$latitude&lon=$longitude&key=${apiKey}&units=metric';

    http.Response response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      temperature = data['data'][0]['temp'].toString() + '°C';
      description = data['data'][0]['weather']['description'];
      icon = data['data'][0]['weather']['icon'];
      isloading = false;
      return [temperature, description, icon];
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return ["", "", ""];
    }
  }
}
