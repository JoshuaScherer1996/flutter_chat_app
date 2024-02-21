import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// UserImagePicker widget allows users to pick an image from their camera.
class UserImagePicker extends StatefulWidget {
  // Constructor for UserImagePicker which requires a callback function to handle the picked image.
  const UserImagePicker({
    super.key,
    required this.onPickImage, // Callback function to be called with the picked image.
  });

  // Callback function that gets called with the picked image file.
  final void Function(File pickedImage) onPickImage;

  @override
  // Creates the state for the UserImagePicker widget.
  State<UserImagePicker> createState() => _UserImagePickerState();
}

// Private State class for UserImagePicker to handle image picking and display.
class _UserImagePickerState extends State<UserImagePicker> {
  // Variable to hold the picked image file.
  File? _pickedImageFile;

  // Method to handle image picking from the camera.
  void _pickImage() async {
    // Uses the ImagePicker plugin to pick an image.
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera, // Sets the image source to camera.
      imageQuality: 50, // Reduces the image quality to 50% to save on storage.
      maxWidth: 150, // Sets the maximum width to 150 to conserve memory.
    );

    // Checks if an image was not picked (user cancelled the operation).
    if (pickedImage == null) {
      return;
    }

    // Updates the state to store the picked image file.
    setState(() {
      _pickedImageFile =
          File(pickedImage.path); // Converts the picked image to a File.
    });

    // Calls the callback function provided in the widget with the picked image.
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  // Builds the UI for the UserImagePicker widget.
  Widget build(BuildContext context) {
    return Column(
      // Arranges the avatar and button in a column.
      children: [
        // Displays the picked image in a circular avatar.
        CircleAvatar(
          radius: 40, // Sets the radius of the circle avatar.
          backgroundColor: Colors.grey, // Sets a grey background color.
          // Displays the picked image if available; otherwise shows the grey background.
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        // Button to trigger the image picking process.
        TextButton.icon(
          onPressed: _pickImage, // Calls _pickImage method when pressed.
          icon:
              const Icon(Icons.image), // Sets the icon next to the button text.
          label: Text(
            'Add Image', // Button text.
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .primary, // Uses the primary color from the theme for the text.
            ),
          ),
        ),
      ],
    );
  }
}
