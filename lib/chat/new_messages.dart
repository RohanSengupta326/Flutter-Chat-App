import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = new TextEditingController();
  String enteredMessage = '';

  void sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        // TimeStamp is coming from firestore
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
            color: Theme.of(context).primaryColor,
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
