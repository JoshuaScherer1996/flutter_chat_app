import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/message_bubble.dart';

/// Displays chat messages in a live-updating list from Firestore.
class ChatMessages extends StatelessWidget {
  // Constructor with an optional Key parameter using super initializer for key.
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieves the currently authenticated user from Firebase Auth.
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    // StreamBuilder widget to build UI based on the stream of chat messages from Firestore.
    return StreamBuilder(
      // Stream that listens to changes in the 'chat' collection of Firestore.
      // Messages are ordered by their creation time in descending order.
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),

      // Builder function to build UI based on the current state of the stream.
      builder: (ctx, chatSnapshots) {
        // Shows a loading indicator while waiting for the data.
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Checks if there's no data or the data is empty, then shows a message.
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        // Displays an error message if there's an error with the stream.
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        // Retrieves the loaded messages from the snapshot.
        final loadedMessages = chatSnapshots.data!.docs;

        // ListView.builder to display each message in the chat.
        return ListView.builder(
          // Adds padding around the list view for better UI.
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          // Reverses the list view to start from the bottom (newest messages).
          reverse: true,
          // The number of items in the list is the number of loaded messages.
          itemCount: loadedMessages.length,
          // itemBuilder to build each message bubble in the list.
          itemBuilder: (ctx, index) {
            // Retrieves the current and next chat message for comparison.
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            // Determines the message bubble type based on whether the next message is from the same user.
            if (nextUserIsSame) {
              // Uses a special MessageBubble constructor for consecutive messages from the same user.
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              // Uses the first MessageBubble constructor for the first message in a sequence or a single message.
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
