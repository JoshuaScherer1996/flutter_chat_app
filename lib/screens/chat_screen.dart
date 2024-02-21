import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat_messages.dart';
import 'package:flutter_chat_app/widgets/new_message.dart';

// ChatScreen widget represents the main screen of the chat application.
class ChatScreen extends StatefulWidget {
  // Constructor for ChatScreen with an optional Key parameter.
  const ChatScreen({super.key});

  @override
  // Creates the state for the ChatScreen widget.
  State<ChatScreen> createState() => _ChatScreenState();
}

// Private State class for ChatScreen to manage its state and handle push notifications.
class _ChatScreenState extends State<ChatScreen> {
  // Method to set up push notifications using Firebase Messaging.
  void setupPushNotification() async {
    // Gets an instance of FirebaseMessaging.
    final fcm = FirebaseMessaging.instance;

    // Requests permission from the user for push notifications.
    await fcm.requestPermission();

    // Subscribes the user to a topic named 'chat' to receive push notifications.
    fcm.subscribeToTopic('chat');
  }

  @override
  // initState is called once when the stateful widget is inserted into the widget tree.
  void initState() {
    super.initState();
    // Calls setupPushNotification to configure push notifications on app start.
    setupPushNotification();
  }

  @override
  // Builds the UI for the ChatScreen widget.
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides a high-level structure for the chat screen.
      appBar: AppBar(
        // AppBar at the top of the screen with a title.
        title: const Text('Flutter Chat'),
        // Actions list containing an IconButton to allow user sign out.
        actions: [
          IconButton(
            // Calls FirebaseAuth.instance.signOut to sign out the user when pressed.
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            // Icon for the button with theme-based color.
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: const Center(
        // Center widget containing a Column widget to organize chat messages and message input.
        child: Column(
          children: [
            // Expanded widget to ensure ChatMessages fills the available space.
            Expanded(
              child: ChatMessages(), // Custom widget to display chat messages.
            ),
            NewMessage(), // Custom widget to input new messages.
          ],
        ),
      ),
    );
  }
}
