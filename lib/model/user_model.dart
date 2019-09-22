class UserModel {
  String uuid;
  String name;
  String displayName;
  String avatar;
  String partnerAvatar;

  UserModel({
    this.uuid,
    this.name,
    this.displayName,
    this.avatar,
    this.partnerAvatar,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    displayName = json['displayName'];
    avatar = json['avatar'];
    partnerAvatar = json['partnerAvatar'];
  }
}
