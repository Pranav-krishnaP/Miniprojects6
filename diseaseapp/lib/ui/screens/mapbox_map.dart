// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// // void main() {
// //   runApp(MaterialApp(
// //     home: Scaffold(
// //       body: MapboxMap(
// //         accessToken: 'pk.eyJ1IjoiYWdyb3Z6biIsImEiOiJjbGoxdGc4ZmcweTllM2dxYXp0czV0N3o1In0.XCDEJXZzw1DcbDJyN5vs6A',
// //         initialCameraPosition: CameraPosition(
// //           target: LatLng(37.7749, -122.4194),
// //           zoom: 11.0,
// //         ),
// //       ),
// //     ),
// //   ));
// // }


// //import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'package:map_launcher/map_launcher.dart';

// import 'package:flutter_map/flutter_map.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';


// class Map extends StatefulWidget {
//   const Map({Key? key}) : super(key: key);

//   @override
//   State<Map> createState() => _MapState();
// }

// class _MapState extends State<Map> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Redirect to Google Maps"),
//             ElevatedButton(
//               onPressed: () {
//                 openMapBox();
//               },
//               child: Text('Show Agriculture related shops near me'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void openMapBox() async {
//   runApp(MaterialApp(
//     home: Scaffold(
//       body: MapboxMap(
//         accessToken: 'pk.eyJ1IjoiYWdyb3Z6biIsImEiOiJjbGoxdGc4ZmcweTllM2dxYXp0czV0N3o1In0.XCDEJXZzw1DcbDJyN5vs6A',
//         initialCameraPosition: CameraPosition(
//           target: LatLng(37.7749, -122.4194),
//           zoom: 11.0,
//         ),
//       ),
//     ),
//   ));
// }


// Future<Position> _determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled don't continue
//     // accessing the position and request users of the
//     // App to enable the location services.
//     return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied, next time you could try
//       // requesting permissions again (this is also where
//       // Android's shouldShowRequestPermissionRationale
//       // returned true. According to Android guidelines
//       // your App should show an explanatory UI now.
//       return Future.error('Location permissions are denied');
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately.
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }

//   // When we reach here, permissions are granted and we can
//   // continue accessing the position of the device.
//   return await Geolocator.getCurrentPosition();
// }
