import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../util.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textFieldController = TextEditingController();

  bool isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColorLight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                        'https://www.woolha.com/media/2020/03/eevee.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Text(
                      'Zionnite ',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  onPressed: null,
                ),
                SizedBox(
                  width: 15.0,
                ),
                IconButton(
                  icon: Icon(
                    Icons.video_call,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  onPressed: null,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [],
      ),
    );
  }
}
