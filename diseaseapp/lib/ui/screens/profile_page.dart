import 'package:flutter/material.dart';
import "package:share_plus/share_plus.dart";
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                title: Text("About"),
                leading: Icon(Icons.info),
                onPressed: (BuildContext context) {
                  _navigateToNextScreen1(context);
                },
              ),
              SettingsTile(
                title: Text('Support'),
                leading: Icon(Icons.support_agent),
                onPressed: (BuildContext) async {
                  String email = Uri.encodeComponent("agrovzn@gmail.com");
                  String subject = Uri.encodeComponent("");
                  String body = Uri.encodeComponent("");
                  print(subject); //output: Hello%20Flutter
                  Uri mail =
                      Uri.parse("mailto:$email?subject=$subject&body=$body");
                  if (await launchUrl(mail)) {
                    //email app opened
                  } else {
                    //email app is not opened
                  }
                },
              ),
              SettingsTile(
                title: Text('Share'),
                leading: Icon(Icons.share),
                onPressed: (BuildContext context) {
                  Share.share("com.example.AgroVision");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToNextScreen1(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => about()));
  }

  void _navigateToNextScreen2(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => suppotrt()));
  }
}

class about extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(
        child: Center(
          child: Text(
            'This application has been built with the vision of supporting farmers all over the region, along with other enthusiasts.\n\n It caters to several different purposes, some of which include Leaf Disease Detection, Chatbot to clear all your queries regarding plants and crops, Navigating Users to nearby farming supply stores, and many more.\n\n Hope you\'ve had a great experience using this platform.\n\n\n\t\t\t\t\t\t\t\t\t Thanks for using this application.\n\n\t\t\t\t\t\t Developed by Pranav, Philip, Kevin and\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tBalendhu.',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}

class suppotrt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: const Center(
        child: Text(
          'This is a new screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
