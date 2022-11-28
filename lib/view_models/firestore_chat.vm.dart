import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firestore_chat/firestore_chat.dart';
import 'package:firestore_chat/services/firestorechat.utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FirestoreChatViewModel extends BaseViewModel {
  //
  FirestoreChatViewModel(this.context, this.chatEntity);
  BuildContext context;
  ChatEntity chatEntity;
  List<ChatMessage> messages = [];
  List<String> messageKeys = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference? chatRef;
  StreamSubscription? chatStreamListener;

  //
  initialise() {
    loadAllMessages();
    // listenToNewMessages();
  }

  loadAllMessages() async {
    //
    setBusy(true);
    try {
      chatRef = firestore.collection("${chatEntity.path}/Activity");
      QuerySnapshot<Object?>? chatData =
          await chatRef!.orderBy("timestamp").get();
      //
      for (var document in chatData.docs) {
        final docData = document.data()! as Map<String, dynamic>;
        ChatMessage message = FirestoreChatUtils.toChatMessage(
          document.id,
          docData,
          chatEntity,
        );
        final msgId = document.id;
        messages.insert(0, message);
        messageKeys.insert(0, msgId);
      }
    } catch (error) {
      if (kDebugMode) {
        print("chat load error ==> $error");
      }
    }
    setBusy(false);
    notifyListeners();
    listenToNewMessages();
  }

  //
  listenToNewMessages() async {
    chatRef = firestore.collection("${chatEntity.path}/Activity");
    chatStreamListener?.cancel();
    chatStreamListener = chatRef
        ?.orderBy("timestamp")
        .limitToLast(1)
        .snapshots(includeMetadataChanges: true)
        .skip(1)
        .listen(
      (event) {
        //
        if (!event.metadata.hasPendingWrites) {
          for (var document in event.docChanges) {
            final docData = document.doc.data()! as Map<String, dynamic>;
            ChatMessage message = FirestoreChatUtils.toChatMessage(
              document.doc.id,
              docData,
              chatEntity,
            );
            //
            final msgId = document.doc.id;
            if (!messageKeys.contains(msgId)) {
              messages.insert(0, message);
              messageKeys.insert(0, msgId);
            }
          }
          //
          notifyListeners();
        }
      },
    );
  }

  void sendMessage(ChatMessage m) async {
    setBusy(true);
    await chatRef?.doc().set(ChatModel.jsonFrom(m));
    setBusy(false);

    try {
      chatEntity.onMessageSent(
        m.text,
        chatEntity,
      );
    } catch (error) {
      if (kDebugMode) {
        print("Error sending chat notification:: >> $error");
      }
    }
  }
}
