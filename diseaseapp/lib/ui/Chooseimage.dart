import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproj/ui/preview_page.dart';

import 'CameraPage.dart';

class Choose extends StatefulWidget {
  const Choose({super.key});

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Ink(
              decoration:
                  ShapeDecoration(color: Colors.green, shape: CircleBorder()),
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
            Ink(
              decoration:
                  ShapeDecoration(color: Colors.green, shape: CircleBorder()),
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
            )
          ],
        ),
      ),
    );
  }
}
