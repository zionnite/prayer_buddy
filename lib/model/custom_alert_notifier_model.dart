import 'dart:convert';

CustomAlertNotifierModel customAlertNotifierModelFromJson(String str) =>
    CustomAlertNotifierModel.fromJson(json.decode(str));

String customAlertNotifierModelToJson(CustomAlertNotifierModel data) =>
    json.encode(data.toJson());

class CustomAlertNotifierModel {
  String message;
  String role;
  String from;
  String to;
  String messageSentStatus;
  bool toUserOnlineStatus;

  CustomAlertNotifierModel({
    required this.message,
    required this.role,
    required this.from,
    required this.to,
    required this.messageSentStatus,
    required this.toUserOnlineStatus,
  });

  factory CustomAlertNotifierModel.fromJson(Map<String, dynamic> json) =>
      CustomAlertNotifierModel(
        message: json["message"],
        role: json["role"],
        from: json["from"],
        to: json["to"],
        messageSentStatus: json["message_sent_status"],
        toUserOnlineStatus: json["to_user_online_status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "role": role,
        "from": from,
        "to": to,
        "message_sent_status": messageSentStatus,
        "to_user_online_status": toUserOnlineStatus,
      };
}
