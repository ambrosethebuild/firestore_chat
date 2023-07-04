import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_chat/firestore_chat.dart';
import 'package:firestore_chat/services/firestorechat.utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';

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
  final firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

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

  //
  onSelectMedia() async {
    try {
      final selectedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (selectedFile != null) {
        uploadPhoteChat(selectedFile);
      }
    } catch (error) {
      if (kDebugMode) {
        print("error selecting image from gallery ==> $error");
      }
    }
  }

  onCameraMedia() async {
    try {
      final selectedFile = await _picker.pickImage(source: ImageSource.camera);
      if (selectedFile != null) {
        uploadPhoteChat(selectedFile);
      }
    } catch (error) {
      if (kDebugMode) {
        print("error selecting image from camera ==> $error");
      }
    }
  }

  //
  uploadPhoteChat(XFile selectedXFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      //add random string to file name
      fileName = "${fileName}_${Random().nextInt(1000000)}";
      //get file extension for XFile path
      String fileExtension = selectedXFile.path.split(".").last;
      fileName = "$fileName.$fileExtension";
      //
      File selectFile = File(selectedXFile.path);
      final storageRef = FirebaseStorage.instance.ref();
      final chatImagesRef = storageRef.child("chat/images/$fileName");
      await chatImagesRef.putFile(selectFile);
      String imageLink = await chatImagesRef.getDownloadURL();
      //send chat
      ChatMessage message = ChatMessage(
        user: chatEntity.mainUser.toChatUser(),
        createdAt: DateTime.now(),
        medias: [
          ChatMedia(
            url: imageLink,
            fileName: fileName,
            type: MediaType.image,
            isUploading: true,
          ),
        ],
      );

      //
      sendMessage(message);
    } catch (error) {
      if (kDebugMode) {
        print("Error uploading file ==> $error");
      }
    }
  }
}
