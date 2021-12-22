import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          itemBuilder: (ctx, index) => Text(
            chatDoc[index]['text'],
          ),
          itemCount: chatDoc.length,
        );
      },
    );
  }
}
