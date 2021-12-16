import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
    // initialized the firebase app before anything

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsUp'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              // to access firebase firestore db, with the cloud_firestore import above
              .collection(
                'chats/oq7d3cbbFAbsoxvZQKX5/messages',
                // accessing the folder where the messages are
              )
              .snapshots(),
          // snapshot returns stream which is the realtime message change reciever,
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final documents = (streamSnapshot.data! as QuerySnapshot).docs;
            // stored the list of messages
            return ListView.builder(
              itemBuilder: (ctx, index) => Text(
                documents[index]['text'],
                // the message with text key
              ),
              itemCount: documents.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection(
            'chats/oq7d3cbbFAbsoxvZQKX5/messages',
          )
              .add(
                // adding new hardcoded messages as a map
            {
              'text': 'Hey wassup users!',
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
