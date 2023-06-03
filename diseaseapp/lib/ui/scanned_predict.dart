import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Predict extends StatefulWidget {
  const Predict({super.key, required this.picture, required this.classname});

  final XFile picture;
  final String classname;

  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  @override
  void initState() {
    super.initState();
    _upload(File(widget.picture.path));
  }

  bool predicting = true;
  final String endPoint = 'http://192.168.18.215:8000/predict';
  Predicted predict = Predicted();
  void _upload(File file) async {
    String fileName = file.path.split('/').last;
    print(fileName);

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      'classname': widget.classname
    });

    Dio dio = new Dio();

    dio.post(endPoint, data: data).then((response) {
      var jsonResponse = jsonDecode(response.toString());
      predict.fromJson(jsonResponse);
      predicting = false;
      setState(() {});
    }).catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Image.file(
              File(widget.picture.path),
              fit: BoxFit.fill,
              width: 250,
              height: 300,
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          predicting == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    children: [
                      const Text(
                        "Predicted",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text("${predict.disclass}"),
                      const SizedBox(
                        height: 50,
                      ),
                      Text("${predict.confidence}")
                    ],
                  ),
                )
        ],
      )),
    );
  }
}

class Predicted {
  String? disclass;
  double? confidence;

  void fromJson(Map<String, dynamic> json) {
    disclass = json["class"];
    confidence = json["confidence"];
  }
}

Future<File> resizeImageToAspectRatio(
    File imageFile, double aspectRatio) async {
  // Read the image file
  final List<int> imageBytes = await imageFile.readAsBytes();

  // Decode the image
  final img.Image? originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    throw Exception('Failed to decode image');
  }

  // Calculate new dimensions based on aspect ratio
  int newWidth, newHeight;
  if (originalImage.width.toDouble() / originalImage.height.toDouble() >
      aspectRatio) {
    newWidth = (originalImage.height.toDouble() * aspectRatio).round();
    newHeight = originalImage.height;
  } else {
    newWidth = originalImage.width;
    newHeight = (originalImage.width.toDouble() / aspectRatio).round();
  }

  // Resize the image
  final img.Image resizedImage =
      img.copyResize(originalImage, width: newWidth, height: newHeight);

  // Save the resized image to a new file
  final Directory temporaryDirectory = await getTemporaryDirectory();
  final String temporaryPath = temporaryDirectory.path;
  final String resizedImagePath = '$temporaryPath/resized_image.png';

  final File resizedImageFile = File(resizedImagePath);
  final List<int> resizedImageBytes = img.encodePng(resizedImage);

  await resizedImageFile.writeAsBytes(resizedImageBytes);

  return resizedImageFile;
}
