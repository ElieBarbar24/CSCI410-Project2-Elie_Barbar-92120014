class RecentChatsModel {
  final int id;
  final String content;
  final String date;
  final int sid;
  final int rid;
  final String type;
  final int relationId;
  final int senderId;
  final String senderName;
  final String senderProfile;
  final int receiverId;
  final String receiverName;
  final String receiverProfile;
  final int unreadedCount;

  RecentChatsModel({
    required this.id,
    required this.content,
    required this.date,
    required this.sid,
    required this.rid,
    required this.type,
    required this.relationId,
    required this.senderId,
    required this.senderName,
    required this.senderProfile,
    required this.receiverId,
    required this.receiverName,
    required this.receiverProfile,
    required this.unreadedCount,
  });

  factory RecentChatsModel.fromJson(Map<String, dynamic> json) {
    return RecentChatsModel(
      id: int.parse(json['ID']),
      content: json['Content'],
      date: json['Date'],
      sid: int.parse(json['Sid']),
      rid: int.parse(json['Rid']),
      type: json['type'],
      relationId: int.parse(json['relationId']),
      senderId: int.parse(json['SenderID']),
      senderName: json['SenderName'],
      senderProfile: json['SenderProfile'],
      receiverId: int.parse(json['ReciverID']),
      receiverName: json['ReciverName'],
      receiverProfile: json['ReceiverProfile'],
      unreadedCount: int.parse(json['UnreadCount'])
    );
  }
}
