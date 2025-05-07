class FriendRequestModel {
  String name;
  String bio;
  String senderId;

  String receiverId;
  String timestamp;
  FriendRequestModel({
    required this.bio,
    required this.name,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });
  FriendRequestModel.fromJson(Map<String, dynamic> json)
    : name = json['name'] ?? '',
      bio = json['bio'] ?? '',
      senderId = json['senderId'] ?? '',
      receiverId = json['receiverId'] ?? '',
      timestamp = json['timestamp'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
    };
  }
}
