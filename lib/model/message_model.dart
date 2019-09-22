class MessageModel {
  String message;
  String id;
  String userId;

  MessageModel();

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    userId = json['userId'];
  }
}
