import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Redirect to Google Maps"),
            ElevatedButton(
              onPressed: () {
                openGoogleMaps();
              },
              child: Text('Show Agriculture related shops near me'),
            ),
          ],
        ),
      ),
    );
  }
}

void openGoogleMaps() async {
  // Check if the Google Maps app is installed
  if (await canLaunchUrlString('comgooglemaps://')) {
    // Construct the search query with the current location
    final Uri googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': 'Agriculture related shops near me',
      },
    );

    // Open Google Maps with the search query
    await launchUrlString(googleMapsUri.toString());
  } else {
    // Fallback to opening the Google Maps website
    final Uri googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': 'Agriculture shops near me',
      },
    );

    // Open Google Maps website with the search query
    await launchUrlString(googleMapsUri.toString());
  }
}
