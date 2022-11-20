import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firestore_chat/models/chat_entity.dart';

class FirestoreChatUtils {
  //
  static ChatMessage toChatMessage(
    String docRef,
    Map<String, dynamic> docData,
    ChatEntity chatEntity,
  ) {
    return ChatMessage(
      user: chatEntity.peers[docData["userId"]]?.toChatUser() ??
          ChatUser(
            id: docData["userId"],
            lastName: "",
            firstName: "",
          ),
      text: docData["text"],
      medias: docData["photos"] != null
          ? (docData["photos"] as List).map((e) {
              return ChatMedia(
                url: e['url'] ?? e ?? "",
                fileName: "",
                type: MediaType.image,
              );
            }).toList()
          : [],
      createdAt: docData["timestamp"] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              docData["timestamp"]?.seconds,
            )
          : DateTime.now(),
      customProperties: {
        "ref": docRef,
      },
    );
  }
}
