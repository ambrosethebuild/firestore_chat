# Firestore Chatπ₯π¬

## βοΈ Getting started

To get started with Firebase, please see the documentation available at https://firebase.flutter.dev/docs/overview

Add **Firestore Chat** to your project by following the instructions on the 
**[install page](https://pub.dev/packages/firestore_chat/install)** and start using it:
```dart
import 'package:firestore_chat/firestore_chat.dart';
```

You can open chat page either via Material route or directly push the chat page

```
await openChatPage(BuildContext context, ChatEntity chatEntity);
```

or

```
FirestoreChat().chatPageWidget(chatEntity)
```

## π± Example
### Opening chat
```dart
final chatEntity = ChatEntity(
    onMessageSent: (message, chatEntity){
//
    },
    mainUser: mainUser,
    peers: peers,
    path: chatPath,
    title: "FIFA 2022 Games",
);


//WAY 1
Navigator.push(
    context,
    FirestoreChat().chatPageWidget(chatEntity),
);

//WAY 2
await openChatPage(context, chatEntity);
...
```


## Models π¦
#### Peer User π¨
##### Fields
* `id` - user Id
* `image` - user image url
* `name` - user display name


### Chat Entity π© 
##### Fields
* `mainUser` - logged in user
* `peers` - Map of users `<user ID, PeerUser>`
* `title` - name of the chat (You can name group chats, can be `nullable`)
* `path` - where the messages/chat should be store on firestore
* `onMessageSent` - callback for when the message is saved to firestore




## License βοΈ
- [MIT](https://github.com/tedcrimson/firestore_chat/blob/master/LICENSE)

## Issues and feedback π­
If you have any suggestion for including a feature or if something doesn't work, feel free to open a Github [issue](https://github.com/ambrosethebuild/firestore_chat/issues) for us to have a discussion on it.