// To parse this JSON data, do
//
//     final connectCallModel = connectCallModelFromJson(jsonString);

import 'dart:convert';

ConnectCallModel connectCallModelFromJson(String str) =>
    ConnectCallModel.fromJson(json.decode(str));

String connectCallModelToJson(ConnectCallModel data) =>
    json.encode(data.toJson());

class ConnectCallModel {
  ConnectCallModel({
    required this.message,
    required this.to,
    required this.from,
    required this.channel,
    required this.expireTime,
    required this.token,
  });

  String message;
  String to;
  String from;
  String channel;
  int expireTime;
  String token;

  factory ConnectCallModel.fromJson(Map<String, dynamic> json) =>
      ConnectCallModel(
        message: json["message"],
        to: json["to"],
        from: json["from"],
        channel: json["channel"],
        expireTime: json["expireTime"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "to": to,
        "from": from,
        "channel": channel,
        "expireTime": expireTime,
        "token": token,
      };
}
