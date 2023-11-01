import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sadi/constants.dart';
import 'package:sadi/screens/login_screen.dart';
import 'package:sadi/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firebaseFirestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  late String messageText;

  final firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    // Retrieve and display messages when the chat screen is loaded
  }

  // Method to send a message
  void sendMessage() {
    firestore.collection('messages').add({
      'text': messageText,
      'sender': user!.email,
      'timestamp': FieldValue.serverTimestamp(), // Set to the current server timestamp
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, WelcomeScreen.id);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      sendMessage(); // Call the method to send the message
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {

  const MessageBubble({super.key, required this.sender, required this.text, required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end :CrossAxisAlignment.start,

        children: [
          Text(sender, style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),),
          Material(
            borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)) :BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)) ,
            elevation: 5,
            color: isMe? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text ',
                style: TextStyle(
                  fontSize: 15,
                  color:isMe? Colors.white :Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firebaseFirestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ); // Show a loading indicator
        }
        final messages = snapshot.data!.docs.reversed;

        List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final currentUser = user!.email;


          final messageBubble = MessageBubble(sender: messageSender, text: messageText, isMe: currentUser == messageSender,);
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

