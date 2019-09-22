class MessageModel {
  String message;
  String id;
  String userId;
  String status = "created"; // created, sent, received

  MessageModel();

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    userId = json['userId'];
    status = json['status'] ?? "created";
  }

  Map<String, dynamic> toJson() {
    return {
      "message": this.message ?? "",
      "id": this.id ?? "",
      "userId": this.userId ?? "",
      "status": this.status ?? "created",
    };
  }
}
