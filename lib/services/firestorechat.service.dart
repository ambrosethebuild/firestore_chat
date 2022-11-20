import 'package:firestore_chat/models/chat_entity.dart';
import 'package:firestore_chat/views/firestore_chat.page.dart';
import 'package:flutter/material.dart';

class FirestoreChat {
  //
  openChatPage(BuildContext context, ChatEntity chatEntity) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FirestoreChatPage(chatEntity),
      ),
    );
  }

  //
  MaterialPageRoute chatPageWidget(ChatEntity chatEntity) {
    return MaterialPageRoute(
      builder: (context) => FirestoreChatPage(chatEntity),
    );
  }
}
