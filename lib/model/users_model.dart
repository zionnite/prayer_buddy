// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  Users({
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.age,
    required this.sex,
    required this.phoneNo,
    required this.userImage,
    required this.status,
    required this.statusMsg,
  });

  String userId;
  String userName;
  String fullName;
  String age;
  String sex;
  String phoneNo;
  String userImage;
  String status;
  String statusMsg;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        userId: json["user_id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        age: json["age"],
        sex: json["sex"],
        phoneNo: json["phone_no"],
        userImage: json["user_image"],
        status: json["status"],
        statusMsg: json["status_msg"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "full_name": fullName,
        "age": age,
        "sex": sex,
        "phone_no": phoneNo,
        "user_image": userImage,
        "status": status,
        "status_msg": statusMsg,
      };
}
