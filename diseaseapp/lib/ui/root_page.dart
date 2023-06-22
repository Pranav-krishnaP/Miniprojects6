import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproj/constants.dart';
import 'package:newproj/models/plants.dart';
import 'package:newproj/ui/Chooseimage.dart';
import 'package:newproj/ui/preview_page.dart';
import 'package:newproj/ui/scan_page.dart';
import 'package:newproj/ui/screens/chat_body.dart';

import 'package:newproj/ui/screens/map.dart';

import 'package:newproj/ui/screens/home_page.dart';
import 'package:newproj/ui/screens/profile_page.dart';
import 'package:page_transition/page_transition.dart';

import 'CameraPage.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Plant> favorites = [];
  List<Plant> myCart = [];

  int _bottomNavIndex = 0;

  //List of the pages
  List<Widget> _widgetOptions() {
    return [HomePage(), const ChatPage(), const Map(), ProfilePage()];
  }

  //List of the pages icons
  List<IconData> iconList = [
    Icons.home,
    Icons.chat_bubble,
    Icons.map,
    Icons.settings,
  ];

  //List of the pages titles
  List<String> titleList = ['Home', 'Chatbot', 'Map', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleList[_bottomNavIndex],
              style: TextStyle(
                color: Constants.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _widgetOptions(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //
          _showDialog(context);
        },
        child: Image.asset(
          'assets/images/code-scan-two.png',
          height: 30.0,
        ),
        backgroundColor: Constants.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: Constants.primaryColor,
          activeColor: Constants.primaryColor,
          inactiveColor: Colors.black.withOpacity(.5),
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
              final List<Plant> favoritedPlants = Plant.getFavoritedPlants();
              final List<Plant> addedToCartPlants = Plant.addedToCartPlants();

              favorites = favoritedPlants;
              myCart = addedToCartPlants.toSet().toList();
            });
          }),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Choose Image From.....'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Ink(
                  decoration: ShapeDecoration(
                      color: Colors.green, shape: CircleBorder()),
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () async {
                      await availableCameras().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CameraPage(cameras: value))));
                    },
                    icon: const Icon(Icons.camera_alt),
                    color: Colors.white,
                  ),
                ),
                const Text("Camera")
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Ink(
                  decoration: ShapeDecoration(
                      color: Colors.green, shape: CircleBorder()),
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () async {
                      XFile picture = await getFromGallery();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviewPage(
                                    picture: picture,
                                  )));
                    },
                    icon: const Icon(Icons.image),
                    color: Colors.white,
                  ),
                ),
                const Text("Gallery")
              ],
            ),
          ],
        ),
      );
    },
  );
}

getFromGallery() async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 400,
    maxHeight: 400,
  );
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
  }
  return pickedFile;
}
