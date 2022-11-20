import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatModel {
  String? id;
  String? message;
  String? image;
  int? senderId;

  ChatModel({
    required this.id,
    required this.message,
    required this.image,
    required this.senderId,
  });

  static Map<String, dynamic> jsonFrom(ChatMessage m) {
    return {
      "text": m.text,
      "photos": [],
      "userId": m.user.id,
      "activityStatus": 1,
      "seenStatus": 1,
      "seenBy": [],
      "timestamp": FieldValue.serverTimestamp(),
    };
  }
}
