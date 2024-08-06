class ChatUser {
  // String image;
  // String name;
  // String about;
  // String createdAt;
  // String id;
  // String lastActive;
  // bool isOnline;
  // String pushToken;
  // String email;

  ChatUser(
      {this.image,
      this.name,
      this.about,
      this.createdAt,
      this.id,
      this.lastActive,
      this.isOnline,
      this.pushToken,
      this.email});
  late final String? image;
  late final String? name;
  late final String? about;
  late final String? createdAt;
  late final String? id;
  late final String? lastActive;
  late final bool? isOnline;
  late final String? pushToken;
  late final String? email;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'];
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
