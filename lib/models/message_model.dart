class MessageModel {
  String id;
  String message;
  var date;
  String friendId;
  String userId;

  MessageModel(
      {this.id = "",
      required this.message,
      required this.date,
      required this.userId,
      required this.friendId});

  MessageModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            message: json['message'],
            date: json['date'],
            userId: json['userId'],
            friendId: json['friendId']);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date": date,
      "message": message,
      "userId": userId,
      "friendId": friendId,
    };
  }
}
