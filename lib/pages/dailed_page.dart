import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:prayer_buddy/component/round_icon_button.dart';

import '../bottom_navigation.dart';

class DialPage extends StatefulWidget {
  DialPage({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  _DialPageState createState() => _DialPageState();
}

class _DialPageState extends State<DialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.purpleAccent,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              const CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/av.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Calling...',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Oxygen',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Nosakhare Atekha Endurance',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Lobster',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundIconButton(
                    icon: Icons.call_end,
                    onPressed: () {
                      Get.to(() => Nav());
                    },
                    color: Colors.redAccent,
                    iconSize: 30.0,
                    widthSize: 50.0,
                    heightSize: 50.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
