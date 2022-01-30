class ResCallAcceptModel {
  ResCallAcceptModel({
    this.channel,
    this.token,
    this.id,
    this.otherUserId,
  });

  String? channel;
  String? token;
  int? id;
  int? otherUserId;

  ResCallAcceptModel.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    token = json['token'];
    id = json['id'];
    otherUserId = int.parse(json['otherUserId']);
  }

  Map<String, dynamic> toJson() => {
        'channel': channel,
        'token': token,
        'id': id,
        'otherUserId': otherUserId,
      };
}

// class ResCallAcceptModel {
//   ResCallAcceptModel({
//     required this.otherUserId,
//     required this.id,
//     required this.channel,
//     required this.token,
//   });
//
//   int otherUserId;
//   int id;
//   String channel;
//   String token;
//
//   factory ResCallAcceptModel.fromJson(Map<String, dynamic> json) =>
//       ResCallAcceptModel(
//         otherUserId: json["otherUserId"],
//         id: json["id"],
//         channel: json["channel"],
//         token: json["token"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "otherUserId": otherUserId,
//         "id": id,
//         "channel": channel,
//         "token": token,
//       };
// }
