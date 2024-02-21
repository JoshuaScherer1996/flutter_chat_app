import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/widgets/user_image_picker.dart';

// Global instance of FirebaseAuth used for authentication operations.
final _firebase = FirebaseAuth.instance;

// AuthScreen widget provides a user interface for authentication, including login and signup.
class AuthScreen extends StatefulWidget {
  // Constructor for AuthScreen with an optional Key parameter.
  const AuthScreen({super.key});

  @override
  // Creates the state for the AuthScreen widget.
  State<AuthScreen> createState() => _AuthScreenState();
}

// Private State class for AuthScreen to manage the authentication form and processes.
class _AuthScreenState extends State<AuthScreen> {
  // GlobalKey used to interact with the form.
  final _formKey = GlobalKey<FormState>();

  // State variables to keep track of form inputs and authentication state.
  var _isLogin = true; // Flag to toggle between login and signup form.
  var _enteredEmail = ''; // User entered email.
  var _enteredPassword = ''; // User entered password.
  var _enteredUername = ''; // User entered username, only for signup.
  File? _selectedImage; // User selected image file, only for signup.
  var _isAuthenticating =
      false; // Flag to indicate ongoing authentication process.

  // Function to handle form submission for both login and signup.
  void _submit() async {
    // Validates the form fields according to their validators.
    final isValid = _formKey.currentState!.validate();

    // Prevents form submission if the form is invalid or in signup mode without an image.
    if (!isValid || (!_isLogin && _selectedImage == null)) {
      return;
    }

    // Saves the form, triggering the onSaved callbacks to update state variables.
    _formKey.currentState!.save();

    // UI feedback to indicate authentication is in progress.
    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Differentiates between login and signup to perform respective Firebase Auth operations.
      if (_isLogin) {
        // Login operation using email and password.
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        // Signup operation followed by uploading user image to Firebase Storage and setting user data in Firestore.
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        // Reference to store the user's profile image in Firebase Storage.
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        // Uploads the image file to Firebase Storage.
        await storageRef.putFile(_selectedImage!);
        // Retrieves the URL for the uploaded image.
        final imageUrl = await storageRef.getDownloadURL();

        // Sets user data in Firestore, including the image URL.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      // Error handling for FirebaseAuth operations.
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      // Resets authentication flag upon error.
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  // Builds the UI for the AuthScreen widget.
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          // Allows the form to be scrollable to accommodate different screen sizes and orientations.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Displays an image at the top of the authentication screen.
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              // Card widget to contain the authentication form.
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      // Form widget to capture and validate user input.
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Conditional widget to pick user image in signup mode.
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          // Form fields for email, username (signup only), and password.
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Adress',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            // Validator functions to ensure valid input.
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid E-Mail address!';
                              }

                              return null;
                            },
                            // onSaved callbacks to update state variables with input data.
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter at least 4 characters.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUername = value!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          // Displays a loading indicator or buttons based on authentication state.
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              // Triggers the _submit function.
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              // Toggles between login and signup mode.
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'You alread have an account.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
