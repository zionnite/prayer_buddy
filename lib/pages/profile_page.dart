import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile_screen';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('Profile Screen'),
        ),
      ),
    );
  }
}
