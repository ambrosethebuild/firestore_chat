import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => openChatFirst(context),
              child: const Text("Open Chat"),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => openChatSecond(context),
              child: const Text("Open Chat"),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //open via direct method call
  openChatFirst(context) async {
    final mainUser = PeerUser(id: "1", name: "User 1");
    final peers = {
      "1": mainUser,
      "2": PeerUser(id: "2", name: "User 2"),
      "3": PeerUser(id: "3", name: "User 3"),
      "4": PeerUser(id: "4", name: "User 4"),
      "5": PeerUser(id: "5", name: "User 5"),
    };

    final chatEntity = ChatEntity(
      mainUser: mainUser,
      peers: peers,
      path: "sport/football/2022/worldcup",
      title: "FIFA 2022 Games",
      onMessageSent: (String message, ChatEntity chatEntity) {
        //handle when chat has been sent to firestore
        //you can use it to send notification or show a toast/snakbar
      },
    );

    await FirestoreChat().openChatPage(context, chatEntity);
  }


  //open via navigation routing 
  openChatSecond(context) async {
    final mainUser = PeerUser(id: "1", name: "User 1");
    final peers = {
      "1": mainUser,
      "2": PeerUser(id: "2", name: "User 2"),
      "3": PeerUser(id: "3", name: "User 3"),
      "4": PeerUser(id: "4", name: "User 4"),
      "5": PeerUser(id: "5", name: "User 5"),
    };

    final chatEntity = ChatEntity(
      mainUser: mainUser,
      peers: peers,
      path: "sport/football/2022/worldcup",
      title: "FIFA 2022 Games",
      onMessageSent: (String message, ChatEntity chatEntity) {
        //handle when chat has been sent to firestore
        //you can use it to send notification or show a toast/snakbar
      },
    );
    Navigator.push(
      context,
      FirestoreChat().chatPageWidget(chatEntity),
    );
  }
}
