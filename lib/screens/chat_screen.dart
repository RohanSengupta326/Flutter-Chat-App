import 'package:chat_app/chat/messages.dart';
import 'package:chat_app/chat/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsUp'),
        actions: [
          DropdownButton<String>(
            // value: String so set generic type String
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).iconTheme.color,
            ),

            items: [
              DropdownMenuItem<String>(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app,
                        color: Theme.of(context).primaryColor),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('LogOut'),
                  ],
                ),
                value: 'logout',
              ),
            ],

            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
                // this automatically handles all the token management and logs user out
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: const [
            Expanded(
              // listview.builder in column doesnt work so Expanded tells listview.builder to contain itself inside the
              // column but scrollable
              child: Messages(),
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
