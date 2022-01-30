import 'dart:convert';

CallRequestModel callRequestModelFromJson(String str) =>
    CallRequestModel.fromJson(json.decode(str));

String callRequestModelToJson(CallRequestModel data) =>
    json.encode(data.toJson());

class CallRequestModel {
  CallRequestModel({
    required this.message,
    required this.role,
    required this.from,
    required this.to,
    required this.toImage,
    required this.toFullName,
    required this.fromImage,
    required this.fromFullName,
    required this.callType,
    required this.channel,
    required this.expireTime,
    required this.token,
  });

  String message;
  String role;
  String from;
  String to;
  String toImage;
  String toFullName;
  String fromImage;
  String fromFullName;
  String callType;
  String channel;
  int expireTime;
  String token;

  factory CallRequestModel.fromJson(Map<String, dynamic> json) =>
      CallRequestModel(
        message: json["message"],
        role: json["role"],
        from: json["from"],
        to: json["to"],
        toImage: json["to_image"],
        toFullName: json["to_full_name"],
        fromImage: json["from_image"],
        fromFullName: json["from_full_name"],
        callType: json["call_type"],
        channel: json["channel"],
        expireTime: json["expireTime"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "role": role,
        "from": from,
        "to": to,
        "to_image": toImage,
        "to_full_name": toFullName,
        "from_image": fromImage,
        "from_full_name": fromFullName,
        "call_type": callType,
        "channel": channel,
        "expireTime": expireTime,
        "token": token,
      };
}
