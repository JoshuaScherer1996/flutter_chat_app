import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
import 'package:flutter_chat_app/screens/splash_screen.dart';
import 'firebase_options.dart';

/// Main entry point of the application.
void main() async {
  // Ensures that widget binding is initialized before running the app.
  // This is necessary for plugins that need to call native code before the runApp method.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes the Firebase application with default options for the current platform.
  // This is necessary for using Firebase services in the app.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Runs the app with App widget as the root of the application.
  runApp(const App());
}

/// Root widget of the FlutterChat application.
class App extends StatelessWidget {
  // Constructor with an optional Key parameter using super initializer for key.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Builds the MaterialApp which sets up the app's navigation and theming.
    return MaterialApp(
      // Title of the application used in the task switcher.
      title: 'FlutterChat',

      // Defines the theme of the app with Material 3 design.
      theme: ThemeData(useMaterial3: true).copyWith(
        // Custom color scheme generated from a seed color.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),

      // Home widget of the application which decides what to show based on authentication state.
      home: StreamBuilder(
        // Stream that listens to the Firebase authentication state changes.
        stream: FirebaseAuth.instance.authStateChanges(),
        // Builder function to build UI based on the current state of the stream.
        builder: (ctx, snapshot) {
          // Shows a loading screen if connection to the auth stream is waiting.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          // If there is data (user is logged in), show the ChatScreen.
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          // If there is no user data (user not logged in), show the AuthScreen for authentication.
          return const AuthScreen();
        },
      ),

      // Hides the debug banner that appears on the top right corner in debug mode.
      debugShowCheckedModeBanner: false,
    );
  }
}
