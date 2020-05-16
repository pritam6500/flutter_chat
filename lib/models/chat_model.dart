import './user_model.dart';

class ChatModel {
  final int senderId;
  final int receiverId;
  final String text;
  final String sendingTime;
  final String receiveTime;
  final String mediaUrl;
  int isSent;
  int isReceived;
  ChatModel(
      {this.senderId,
      this.receiverId,
      this.text,
      this.sendingTime,
      this.receiveTime,
      this.mediaUrl,
      this.isSent,
      this.isReceived});
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['senderId'] = this.senderId ?? null;
    map['receiverId'] = this.receiverId ?? '';
    map['text'] = this.text;
    map['sendingTime'] = this.sendingTime;
    map['receiveTime'] = this.receiveTime;
    map['mediaUrl'] = this.mediaUrl ?? '';
    map['isSent'] = this.isSent ?? 0;
    map['isReceived'] = this.isReceived ?? 0;
    return map;
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        senderId: int.parse(json['senderId'].toString()),
        receiverId: int.parse(json['receiverId'].toString()),
        text: json['text'],
        sendingTime: json['sendingTime']?? '',
        receiveTime: json['receiveTime'] ?? '',
        mediaUrl: json['mediaUrl'] ?? '',
        isSent: json['isSent'] ?? 0,
        isReceived: json['isReceived'] ?? 0
        );
  }
}


