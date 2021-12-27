import 'package:chat_app/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userIdInfo = FirebaseAuth.instance.currentUser;
    // to get the current users details
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          // orders messages with time
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDoc = (snapshot.data! as QuerySnapshot).docs;
        return ListView.builder(
          reverse: true,
          // to show at the bottom of the screen not top
          itemBuilder: (ctx, index) => MessageBubble(
            chatDoc[index]['text'],
            chatDoc[index]['userId'] == userIdInfo!.uid ? true : false,
            chatDoc[index]['username'],
            chatDoc[index]['dpUrl'],
            key: ValueKey(chatDoc[index].id),
            // unique key with the document Id in firebase 
          ),

          itemCount: chatDoc.length,
        );
      },
    );
  }
}
