class ChatUser {
  ChatUser({
    required this.image,
    required this.email,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.lastActive,
    required this.id,
    required this.isOnline,
    required this.pushToken,
  });
  late String image;
  late String name;
  late String about;
  late String email;
  late String createdAt;
  late String lastActive;
  late String id;
  late bool isOnline;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    lastActive = json['last_active'] ?? '';
    id = json['id'] ?? '';
    isOnline = json['is_online'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['email'] = email;
    _data['name'] = name;
    _data['about'] = about;
    _data['created_at'] = createdAt;
    _data['last_active'] = lastActive;
    _data['id'] = id;
    _data['is_online'] = isOnline;
    _data['push_token'] = pushToken;
    return _data;
  }
}