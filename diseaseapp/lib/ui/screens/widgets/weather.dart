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
    print("Hello");
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
    Timer(const Duration(milliseconds: 50), getWeatherData);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        height: 200,
        child: Scaffold(
          body: Container(
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
              ],
            ),
          ),
        ));
  }
}
