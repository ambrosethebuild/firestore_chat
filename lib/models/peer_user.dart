import 'package:dash_chat_custom/dash_chat_custom.dart';

class PeerUser {
  late final String? image;
  late final String name;
  late final String id;

  PeerUser({required this.id, required this.name, this.image});

  ChatUser toChatUser() {
    return ChatUser(
      id: id,
      profileImage: image,
      firstName: name,
      lastName: "",
    );
  }
}
