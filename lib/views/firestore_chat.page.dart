import 'package:firestore_chat/models/chat_entity.dart';
import 'package:firestore_chat/view_models/firestore_chat.vm.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class FirestoreChatPage extends StatelessWidget {
  const FirestoreChatPage(this.chatEntity, {Key? key}) : super(key: key);

  final ChatEntity chatEntity;

  //
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: Scaffold(
        appBar: AppBar(
          title: Text(chatEntity.title ?? ""),
          // backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ViewModelBuilder<FirestoreChatViewModel>.reactive(
          viewModelBuilder: () => FirestoreChatViewModel(context, chatEntity),
          onViewModelReady: (model) => model.initialise(),
          builder: (context, vm, child) {
            return Theme(
              data: Theme.of(context),
              child: DashChat(
                currentUser: chatEntity.mainUser.toChatUser(),
                onSend: vm.sendMessage,
                messages: vm.messages,
                inputOptions: InputOptions(
                  inputTextStyle: TextStyle(
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  trailing: chatEntity.supportMedia
                      ? [
                          const SizedBox(width: 10),
                          //send media button
                          IconButton(
                            icon: Icon(
                              Icons.photo,
                              color: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: vm.onSelectMedia,
                          ),
                          const SizedBox(width: 10),
                          //send media from camera
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: vm.onCameraMedia,
                          ),
                          const SizedBox(width: 10),
                        ]
                      : [const SizedBox.shrink()],
                ),
                messageListOptions: MessageListOptions(
                  showDateSeparator: true,
                  dateSeparatorFormat: DateFormat('dd MMM yyyy',
                      Localizations.localeOf(context).languageCode),
                  chatFooterBuilder: vm.isBusy
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
