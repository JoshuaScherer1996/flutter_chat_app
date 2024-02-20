# flutter_chat_app

Favorite Places is a Flutter app that allows you to keep track of your favorite locations! Take a picture of a place that is special to you and add it's location either through your current location or mark it on the map. That way you can always revisit those memories through accessing your saved places. This code was produced during the completion of the Flutter course [A Complete Guide to the Flutter SDK & Flutter Framework for building native iOS and Android apps](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/37130436#overview).

## Basic functionality
- Example

### Screenshots 
<div align="center">
  <img src="empty_locations.png" alt="Start screen without locations" width="200"/>
  <img src="form_empty.png" alt="Form to input new locations" width="200"/>
</div>

## Topics covered 

- Used firebase for [user authentication](https://firebase.google.com/docs/auth/flutter/start) based on e-mail and password.
- Setup and included all the necessary tools from the firebase sdk.
- Learned about streams being similar to futures. While futures provide one value and are done a stream can provide multiple values over time.
- Used StreamBuilder and authStateChanges() to adjust the shown screen based on the value the function yields as a stream.
- Used the signOut() method from the firebase sdk to log users out.
- Used [firebase storage](https://firebase.google.com/docs/storage/flutter/start) to upload profile images.
- Used [firebase firestore](https://firebase.google.com/docs/firestore) to store the username, email and image url.
- Further used another collection inside firestore to store the chat messages.
- Used FocusScope and the unfocus() method to immediately close the keyboard after finishing the input.
- Included the pre defined bubble widget from [github](https://github.com/academind/flutter-complete-guide-course-resources/blob/main/Lecture%20Attachments/14%20Chat%20App/message_bubble.dart).
- Used FirebaseMessaging to request permission for notifications and send them from firebase.
- Learned how to add functions to firebase to be able to send push notifications every time a new message is send.