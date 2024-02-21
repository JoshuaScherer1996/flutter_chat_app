import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// NewMessage widget for creating and submitting new chat messages.
class NewMessage extends StatefulWidget {
  // Constructor with an optional Key parameter using super initializer for key.
  const NewMessage({super.key});

  @override
  // Creates the state for the NewMessage widget.
  State<NewMessage> createState() => _NewMessageState();
}

// Private State class for NewMessage widget to manage message input and submission.
class _NewMessageState extends State<NewMessage> {
  // Controller for the text field to input messages.
  final _messageController = TextEditingController();

  @override
  // Dispose method to clean up the controller when the widget is removed from the widget tree.
  void dispose() {
    _messageController
        .dispose(); // Disposes the text controller to prevent memory leaks.
    super.dispose();
  }

  // Method to handle the submission of the message.
  void submitMessage() async {
    // Retrieves the text from the text field.
    final enteredMessage = _messageController.text;

    // Checks if the entered message is not empty, ignores whitespace.
    if (enteredMessage.trim().isEmpty) {
      return; // Exits the method if no message is entered.
    }

    // Unfocuses the text field to hide the keyboard.
    FocusScope.of(context).unfocus();

    // Clears the text field after the message is submitted.
    _messageController.clear();

    // Retrieves the current user from FirebaseAuth.
    final user = FirebaseAuth.instance.currentUser!;
    // Fetches the user's data from Firestore based on their UID.
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // Adds the new message to the 'chat' collection in Firestore.
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage, // The message text.
      'createdAt': Timestamp.now(), // Timestamp of the message creation.
      'userId': user.uid, // UID of the user who sent the message.
      'username': userData.data()!['username'], // Username of the sender.
      'userImage': userData.data()!['image_url'], // Image URL of the sender.
    });
  }

  @override
  // Builds the NewMessage widget UI.
  Widget build(BuildContext context) {
    return Padding(
      // Padding around the row for aesthetic spacing.
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      // Row widget to layout the text field and send button.
      child: Row(
        children: [
          // Expands the text field to take up all available space.
          Expanded(
            child: TextField(
              controller:
                  _messageController, // Associates the controller with the text field.
              textCapitalization: TextCapitalization
                  .sentences, // Capitalizes the first letter of sentences.
              autocorrect: true, // Enables autocorrect for the text input.
              enableSuggestions: true, // Enables keyboard suggestions.
              decoration: InputDecoration(
                  labelText: 'Send a message...'), // Sets the placeholder text.
            ),
          ),
          // IconButton to send the message.
          IconButton(
            color: Theme.of(context)
                .colorScheme
                .primary, // Uses the primary color from the theme.
            onPressed:
                submitMessage, // Calls the submitMessage method when pressed.
            icon: const Icon(Icons.send), // Uses the send icon.
          ),
        ],
      ),
    );
  }
}
