import 'package:flutter/material.dart';

// SplashScreen widget displays a simple loading screen to the user.
class SplashScreen extends StatelessWidget {
  // Constructor for SplashScreen with an optional Key parameter.
  const SplashScreen({super.key});

  @override
  // Builds the UI of the SplashScreen widget.
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget provides a high-level structure for the splash screen.
      appBar: AppBar(
        // AppBar at the top of the screen with the title.
        title: const Text('Flutter Chat'),
      ),
      body: const Center(
        // Center widget to align the loading message in the center of the screen.
        child: Text('Loading...'),
        // Text widget displays a simple loading message to inform the user.
      ),
    );
  }
}
