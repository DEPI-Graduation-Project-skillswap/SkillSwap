class NotificationModel {
  final String id;
  final String userId;
  final String senderId;
  final String senderName;
  final String message;
  final String type; // 'message', 'friend_request', etc.
  final String timestamp;
  final bool isRead;
  final String? conversationId; // Only for message notifications
  
  NotificationModel({
    required this.id,
    required this.userId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.conversationId,
  });
  
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      timestamp: json['timestamp'] ?? '',
      isRead: json['isRead'] ?? false,
      conversationId: json['conversationId'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'type': type,
      'timestamp': timestamp,
      'isRead': isRead,
      'conversationId': conversationId,
    };
  }
}
