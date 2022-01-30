import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/route_manager.dart';
import 'package:prayer_buddy/component/round_icon_button.dart';
import 'package:prayer_buddy/controllers/custom_alert_notifer_controller.dart';
import 'package:prayer_buddy/pages/home_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wakelock/wakelock.dart';

class IncomingCallPage extends StatefulWidget {
  IncomingCallPage({
    Key? key,
    required this.type,
    this.isOutGoing = false,
    required this.socket,
    required this.to,
    required this.from,
    required this.to_full_name,
    required this.to_image,
    required this.from_full_name,
    required this.from_image,
  }) : super(key: key);

  final String type;
  final bool isOutGoing;
  final IO.Socket socket;
  final String to;
  final String to_full_name;
  final String to_image;
  final String from;
  final String from_full_name;
  final String from_image;

  @override
  _IncomingCallPageState createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  final custom_alert_notifer = CustomAlertNotifierController().getXID;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    Wakelock.enable(); // Turn on wakelock feature till call is running
    //To Play Ringtone
    if (!widget.isOutGoing) {
      FlutterRingtonePlayer.play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.electronic,
        looping: true,
        volume: 0.5,
        asAlarm: false,
      );
    }
    _timer = Timer(const Duration(milliseconds: 60 * 1000), _endCall);
  }

  @override
  void dispose() {
    //To Stop Ringtone
    if (!widget.isOutGoing) {
      FlutterRingtonePlayer.stop();
    }
    _timer.cancel();
    super.dispose();
  }

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
              CircleAvatar(
                radius: 100,
                backgroundImage: (widget.isOutGoing)
                    ? NetworkImage(widget.to_image)
                    : NetworkImage(widget.from_image),
              ),
              const SizedBox(
                height: 30,
              ),
              (widget.isOutGoing)
                  ? Column(
                      children: const [
                        Text(
                          'Calling...',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Oxygen',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : Container(),
              Text(
                (widget.isOutGoing)
                    ? widget.to_full_name
                    : widget.from_full_name,
                style: const TextStyle(
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
                      var msgJson = {
                        "message": 'trying something',
                        "to": widget.to,
                        "from": widget.from
                      };
                      (widget.isOutGoing)
                          ? widget.socket.emit('hangUp', msgJson)
                          : widget.socket.emit('rejectCall', msgJson);
                      _timer.cancel();
                      _endCall();
                    },
                    color: Colors.redAccent,
                    iconSize: 30.0,
                    widthSize: 50.0,
                    heightSize: 50.0,
                  ),
                  (!widget.isOutGoing)
                      ? const SizedBox(
                          width: 25,
                        )
                      : Container(),
                  (!widget.isOutGoing)
                      ? RoundIconButton(
                          icon: Icons.call,
                          onPressed: () {
                            var msgJson = {
                              "message": 'trying something',
                              "to": widget.to,
                              "from": widget.from
                            };
                            widget.socket.emit('acceptCall', msgJson);
                            //Get.to(() => VideoCallPage());
                            _timer.cancel();
                          },
                          color: Colors.green,
                          iconSize: 30.0,
                          widthSize: 50.0,
                          heightSize: 50.0,
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _endCall() {
    if (!widget.isOutGoing) {
      FlutterRingtonePlayer.stop();
    }
    Wakelock.disable(); // Tu
    _timer.cancel(); // rn off wakelock feature after call end
    Get.to(() => HomePage());
  }
}
