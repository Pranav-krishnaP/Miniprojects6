import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:map_launcher/map_launcher.dart';

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

  Position ll = await _determinePosition();
  if (await MapLauncher.isMapAvailable(MapType.google) != null) {
    await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(ll.latitude, ll.longitude),
        title: "My location");
    // query: 'agriculture related shops');
    // final availableMaps = await MapLauncher.installedMaps;
    // if (availableMaps.isNotEmpty) {
    // final map = availableMaps.firstWhere(
    //   (m) => m.mapType == MapType.google,
    //   orElse: () => availableMaps.first,
    // );
    // final url = 'https://www.google.com/maps/search/?api=1&query=$searchQuery';

    // await map.(url);
    // final Uri googleMapsUri = Uri(
    //   scheme: 'https',
    //   host: 'www.google.com',
    //   path: '/maps/search/',
    //   queryParameters: {
    //     'api': '1',
    //     'query': 'agriculture related shops',
    //   },
    // );
    // await launchUrlString(googleMapsUri.toString());
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

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
