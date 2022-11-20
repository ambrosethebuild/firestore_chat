import 'package:firestore_chat/models/peer_user.dart';

class ChatEntity {
  final PeerUser mainUser;
  final Map<String, PeerUser> peers;
  final String path;
  final String? title;
  final Function(
    String message,
    ChatEntity chatEntity,
  ) onMessageSent;

  ChatEntity({
    required this.mainUser,
    required this.peers,
    required this.path,
    required this.title,
    required this.onMessageSent,
  });
}
