import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:lib/src/api/weather_api.dart';

const weatherbitApiKey = 'c376723d8a9f4e45b8d187c5a116f88a'; 

Future<Map<String, dynamic>> fetchWeatherData(double lat, double lon) async {
  final response = await http.get(Uri.parse(
      'https://api.weatherbit.io/v2.0/current?lat=$lat&lon=$lon&key=$weatherbitApiKey'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}