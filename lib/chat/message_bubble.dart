import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String chatText;
  final bool isMe;
  final Key key;
  final String dpUrl;
  final String userName;

  MessageBubble(this.chatText, this.isMe, this.userName, this.dpUrl,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.deepPurpleAccent,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(12),
                  topLeft: const Radius.circular(12),
                  bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      color: isMe ? Colors.deepPurpleAccent : Colors.blueAccent,
                    ),
                  ),
                  Text(
                    chatText,
                    style: const TextStyle(
                      color: Colors.white,
                      
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(dpUrl),
          ),
        ),
      ],
      clipBehavior: Clip.none,
      // so that the dpUrl doesnt get clipped
    );
  }
}
