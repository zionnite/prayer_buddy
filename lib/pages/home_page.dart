import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prayer_buddy/component/round_icon_button.dart';
import 'package:prayer_buddy/controllers/custom_alert_notifer_controller.dart';
import 'package:prayer_buddy/controllers/handler_call_controller.dart';
import 'package:prayer_buddy/controllers/users_controller.dart';
import 'package:prayer_buddy/model/call_request_model.dart';
import 'package:prayer_buddy/model/connect_call_model.dart';
import 'package:prayer_buddy/model/custom_alert_notifier_model.dart';
import 'package:prayer_buddy/pages/incoming_call_page.dart';
import 'package:prayer_buddy/pages/video_call_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usersContrl = UsersController().getXID;
  final custom_alert_notifer = CustomAlertNotifierController().getXID;
  final handleCallRequestController = HandlerCallController().getXID;

  bool widgetLoading = true;
  bool isLoading = false;

  late IO.Socket socket;

  String? my_id;
  String? my_image;
  String? my_full_name;

  static String server_ip =
      // Platform.isIOS ? "http://localhost" : "http://10.0.2.2";
      Platform.isIOS ? "http://localhost" : "http://192.168.43.123";
  static int server_port = 4000;

  getIfUsersLoaded() {
    var loading = usersContrl.isDataProcessing.value;
    if (loading) {
      setState(() {
        widgetLoading = false;
      });
    }
  }

  _initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id1 = prefs.getString('user_id');
    var full_name1 = prefs.getString('full_name');
    var user_img1 = prefs.getString('user_img');
    // var user_name1 = prefs.getString('user_name');

    setState(() {
      my_id = user_id1!;
      my_full_name = full_name1;
      my_image = user_img1;
    });

    print('my id ${my_id}');
    usersContrl.getUsers(my_id);

    final Map<String, String> userMap = {
      'from': my_id.toString(),
    };
    socket = IO.io(
        // 'https://protected-tor-59104.herokuapp.com',
        '$server_ip:$server_port',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery(userMap)
            .build());
    socket.connect();
    socketListener();
  }

  @override
  void initState() {
    _initUserDetail();

    super.initState();

    Future.delayed(new Duration(seconds: 0), () {
      if (mounted) {
        setState(() {
          getIfUsersLoaded();
        });
      }
    });
  }

  socketListener() {
    socket.on('test', (data) {
      print(data);
    });

    socket.on('onConnect', onConnect);
    socket.on('onCallRequest', handleOnCallRequest);
    socket.on('onAcceptCall', handleOnAcceptCall);
    socket.on('goToCallPage', handleOnGoToCallPage);
    socket.on('onRejectCall', handleOnRejectCall);
    socket.once('customAlertNotifier', handleOnCustomAlertNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
              child: Row(
                children: const [
                  Text(
                    'Prayer Buddy',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Pacifico',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Prayer Partner',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'Lobster',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: usersContrl.usersList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var currentItem = usersContrl.usersList[index];
                            if (index == usersContrl.usersList.length - 1 &&
                                isLoading == true) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (usersContrl.usersList[index].userId == null) {
                              usersContrl.isMoreDataAvailable.value = false;

                              return Container();
                            }
                            if (usersContrl.usersList[index].userId == null &&
                                (usersContrl.usersList[index].status ==
                                        "end 1" ||
                                    usersContrl.usersList[index].status ==
                                        "end 2")) {
                              false;

                              return const Text('Empty');
                            }
                            return Column(
                              children: [
                                Card(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CircleAvatar(
                                          radius: 50,
                                          child: CircleAvatar(
                                            radius: 48.0,
                                            backgroundImage: NetworkImage(
                                              currentItem.userImage,
                                              // 'https://rcnapp.one/agent/zionnite/images/c3c1bab8dcd8879c9c32760b5136978c.jpg',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 20.0, left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                currentItem.fullName,
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        currentItem.phoneNo,
                                                        style: const TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 0.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        currentItem.sex,
                                                        style: const TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Row(
                                                  // mainAxisSize:
                                                  //     MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,

                                                  children: [
                                                    Expanded(
                                                      child: RoundIconButton(
                                                        icon: Icons.comment,
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              ChatPage.id);
                                                        },
                                                      ),
                                                    ),
                                                    // const Expanded(
                                                    //   child: SizedBox(
                                                    //     width: 10.0,
                                                    //   ),
                                                    // ),
                                                    Expanded(
                                                      child: RoundIconButton(
                                                        icon: Icons.call,
                                                        onPressed: () async {
                                                          var status = await [
                                                            Permission
                                                                .microphone,
                                                            Permission.camera
                                                          ].request();

                                                          var msgJson = {
                                                            "message":
                                                                'trying something',
                                                            "role": "publisher",
                                                            "from": my_id,
                                                            "to": currentItem
                                                                .userId,
                                                            "to_image":
                                                                currentItem
                                                                    .userImage,
                                                            "to_full_name":
                                                                currentItem
                                                                    .fullName,
                                                            "from_image":
                                                                my_image,
                                                            "from_full_name":
                                                                my_full_name,
                                                            "call_type": "voice"
                                                          };
                                                          socket.emit(
                                                              'connectCall',
                                                              msgJson);
                                                          Get.to(() =>
                                                              IncomingCallPage(
                                                                type:
                                                                    'voice_call',
                                                                isOutGoing:
                                                                    true,
                                                                socket: socket,
                                                                from: my_id
                                                                    .toString(),
                                                                to: currentItem
                                                                    .userId,
                                                                to_image:
                                                                    currentItem
                                                                        .userImage,
                                                                from_image:
                                                                    my_image!,
                                                                from_full_name:
                                                                    my_full_name!,
                                                                to_full_name:
                                                                    currentItem
                                                                        .fullName,
                                                              ));
                                                        },
                                                      ),
                                                    ),
                                                    // const Expanded(
                                                    //   child: SizedBox(
                                                    //     width: 10.0,
                                                    //   ),
                                                    // ),
                                                    Expanded(
                                                      child: RoundIconButton(
                                                        icon: Icons.video_call,
                                                        onPressed: () {
                                                          var msgJson = {
                                                            "message":
                                                                'trying something',
                                                            "role": "publisher",
                                                            "from": my_id,
                                                            "to": currentItem
                                                                .userId,
                                                            "to_image":
                                                                currentItem
                                                                    .userImage,
                                                            "to_full_name":
                                                                currentItem
                                                                    .fullName,
                                                            "from_image":
                                                                my_image,
                                                            "from_full_name":
                                                                my_full_name,
                                                            "call_type": "video"
                                                          };
                                                          socket.emit(
                                                              'connectCall',
                                                              msgJson);
                                                          Get.to(() =>
                                                              IncomingCallPage(
                                                                type:
                                                                    'video_call',
                                                                isOutGoing:
                                                                    true,
                                                                socket: socket,
                                                                from: my_id
                                                                    .toString(),
                                                                to: currentItem
                                                                    .userId,
                                                                to_image:
                                                                    currentItem
                                                                        .userImage,
                                                                from_image:
                                                                    my_image!,
                                                                from_full_name:
                                                                    my_full_name!,
                                                                to_full_name:
                                                                    currentItem
                                                                        .fullName,
                                                              ));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        )),
                  ],
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
              child: Row(
                children: const [
                  Text(
                    'Other Groups',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Pacifico',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: Column(
                children: [
                  ListTile(
                    leading: const Text(''),
                    title: const Text("General Prayer Room"),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ChatPage.id);
                            },
                            child: Container(
                              color: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: const Text(
                                'Join',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Group is Active',
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_rate_sharp),
                    title: const Text("Prophetic Watch"),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ChatPage.id);
                            },
                            child: Container(
                              color: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: const Text(
                                'Join',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Group is Active',
                          ),
                        ],
                      ),
                    ),
                    onTap: () {/* react to the tile being tapped */},
                    trailing: const Icon(
                      Icons.album_sharp,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_rate_sharp),
                    title: const Text("Intercessor"),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ChatPage.id);
                            },
                            child: Container(
                              color: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: const Text(
                                'Join',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Group is Active',
                          ),
                        ],
                      ),
                    ),
                    onTap: () {/* react to the tile being tapped */},
                    trailing: const Icon(
                      Icons.album_sharp,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_rate_sharp),
                    title: const Text("Missionary"),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ChatPage.id);
                            },
                            child: Container(
                              color: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: const Text(
                                'Join',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'Group is Active',
                          ),
                        ],
                      ),
                    ),
                    onTap: () {/* react to the tile being tapped */},
                    trailing: Icon(
                      Icons.album_sharp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onConnect(data) {}

  handleOnCallRequest(response) async {
    //print(data);
    var data = await callRequestModelFromJson(response);

    Get.to(() => IncomingCallPage(
          type: data.callType,
          isOutGoing: false,
          socket: socket,
          from: data.from,
          to: data.to,
          to_image: data.toImage,
          from_full_name: data.fromFullName,
          to_full_name: data.toFullName,
          from_image: data.fromImage,
        ));
  }

  handleOnAcceptCall(response) async {
    //check if app is in background then bring to foreground

    var data = await connectCallModelFromJson(response);
    Get.to(
      () => VideoCallPage(
        channel: data.channel,
        token: data.token,
        from: data.from,
        to: data.to,
        role: ClientRole.Audience,
      ),
    );
  }

  handleOnGoToCallPage(response) async {
    FlutterRingtonePlayer.stop();
    var data = await connectCallModelFromJson(response);
    Get.to(
      () => VideoCallPage(
        channel: data.channel,
        token: data.token,
        from: data.from,
        to: data.to,
        role: ClientRole.Broadcaster,
      ),
    );
  }

  handleOnRejectCall(data) {
    FlutterRingtonePlayer.stop();
    Get.to(() => HomePage());
  }

  handleOnCustomAlertNotifier(data) async {
    // try {
    //   final myObject = json.decode(data) as Object?;
    //   if (myObject is! Map) throw FormatException();
    //   final message = myObject['message'] as String? ?? '';
    //   final from = myObject['from'] as String? ?? 0;
    //
    //   print('message == ${message}');
    //   print('from == ${from}');
    // } catch (error) {
    //   print('JSON is in the wrong format');
    // }

    // try {
    //   var myObject = json.decode(data);
    //   var message = myObject['message'];
    //   var from = myObject['from'];
    //
    //   print('message == ${message}');
    //   print('from == ${from}');
    // } catch (error) {
    //   print('JSON is in the wrong format');
    // }

    print(data);
    CustomAlertNotifierModel alert = customAlertNotifierModelFromJson(data);
    var online_status = alert.toUserOnlineStatus;
    custom_alert_notifer.user_online_status(online_status);

    Future.delayed(const Duration(seconds: 4), () {
      Get.snackbar('Offline', "call can't connect, because user is not online",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      Get.to(() => HomePage());
    });

    //print('Alert Message ${alert.message}');

    // try {
    //   dynamic myMap = json.decode(data);
    //   if (myMap is! Map<String, dynamic>) throw const FormatException();
    //
    //   CustomAlertNotifierModel alert =
    //       await CustomAlertNotifierModel.fromJson(myMap);
    //   custom_alert_notifer.alert.add(alert);
    //
    // } catch (error) {
    //   print('JSON is in the wrong format');
    // }
    //

    // custom_alert_notifer.alert.clear();
    // custom_alert_notifer.alert.add(customAlertNotifierModelFromJson(data));
    //
    // for (var i = 0; i < custom_alert_notifer.alert.length; i++) {
    //   print(custom_alert_notifer.alert[i].message);
    // }
  }
}
