class ChatConversationModel {
  final String id;
  final String userId1;
  final String userId2;
  final String lastMessage;
  final String lastMessageTime;
  final bool unreadMessages;
  final String userName;  // Name of the other user in the conversation
  final String userBio;   // Bio of the other user

  ChatConversationModel({
    required this.id,
    required this.userId1,
    required this.userId2,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadMessages,
    required this.userName,
    required this.userBio,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      id: json['id'] ?? '',
      userId1: json['userId1'] ?? '',
      userId2: json['userId2'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] ?? '',
      unreadMessages: json['unreadMessages'] ?? false,
      userName: json['userName'] ?? '',
      userBio: json['userBio'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId1': userId1,
      'userId2': userId2,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadMessages': unreadMessages,
      'userName': userName,
      'userBio': userBio,
    };
  }
}
