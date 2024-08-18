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
      {required this.image,
      required this.name,
      required this.about,
      required this.createdAt,
      required this.id,
      required this.lastActive,
      required this.isOnline,
      required this.pushToken,
      required this.email});
  late String image;
  late String name;
  late String about;
  late String createdAt;
  late String id;
  late String lastActive;
  late bool isOnline;
  late String pushToken;
  late String email;
  ChatUser copyWith({
    String? id,
    String? name,
    String? email,
    String? about,
    String? image,
    String? createdAt,
    bool? isOnline,
    String? lastActive,
    String? pushToken,
  }) {
    return ChatUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      pushToken: pushToken ?? this.pushToken,
    );
  }

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
