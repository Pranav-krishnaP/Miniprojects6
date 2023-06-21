import 'package:flutter/material.dart';

import 'package:settings_ui/settings_ui.dart';

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
                onPressed: (BuildContext context) {
                  _navigateToNextScreen2(context);
                },
              ),
              SettingsTile(
                title: Text('share'),
                leading: Icon(Icons.share),
                onPressed: (BuildContext context) {
                  _navigateToNextScreen3(context);
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

  void _navigateToNextScreen3(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => share()));
  }
}

class about extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(
        child: Text(
          'This is a new screen',
          style: TextStyle(fontSize: 24.0),
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

class share extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share')),
      body: const Center(
        child: Text(
          'This is a new screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
