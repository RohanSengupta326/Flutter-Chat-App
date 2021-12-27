import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = new TextEditingController();
  String enteredMessage = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final userId = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId!.uid)
        .get();
    // importing the users collection so i can get the username field
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        // TimeStamp is coming from firestore
        'userId': userId.uid,
        // also storing the userId
        'username': userData['username'],
        // also storing the username
        'dpUrl': userData['dpUrl'],
        // also adding the dpurl to chat collection
      },
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'New message!',
              ),
              onChanged: (value) {
                setState(() {
                  enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: enteredMessage.trim().isEmpty
                ? Colors.grey
                : Theme.of(context).primaryColor,
            onPressed: enteredMessage.trim().isEmpty ? null : sendMessage,
            icon: Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
