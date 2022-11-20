import 'package:firestore_chat/models/chat_entity.dart';
import 'package:firestore_chat/view_models/firestore_chat.vm.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:stacked/stacked.dart';

class FirestoreChatPage extends StatelessWidget {
  const FirestoreChatPage(this.chatEntity, {Key? key}) : super(key: key);

  final ChatEntity chatEntity;

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatEntity.title ?? ""),
      ),
      body: ViewModelBuilder<FirestoreChatViewModel>.reactive(
        viewModelBuilder: () => FirestoreChatViewModel(context, chatEntity),
        onModelReady: (model) => model.initialise(),
        builder: (context, vm, child) {
          return DashChat(
            currentUser: chatEntity.mainUser.toChatUser(),
            onSend: vm.sendMessage,

            messages: vm.messages,
            // inputOptions: const InputOptions(
            //   trailing: [
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Icon(
            //         Ionicons.image,
            //       ),
            //     ),
            //   ],
            // ),
            messageListOptions: MessageListOptions(
              showDateSeparator: false,
              chatFooterBuilder: vm.isBusy
                  ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
