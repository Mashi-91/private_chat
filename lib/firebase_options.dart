// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAZw9HU0YI7UUScBFsrzYCyOixUBr6dZqg',
    appId: '1:228661775129:web:c9edea507941c52b511388',
    messagingSenderId: '228661775129',
    projectId: 'private-chat-f61e7',
    authDomain: 'private-chat-f61e7.firebaseapp.com',
    storageBucket: 'private-chat-f61e7.appspot.com',
    measurementId: 'G-G3LSZ51YMZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBzsPVhXsuVU5bNWE-w-ine1TmV_jNHuCk',
    appId: '1:228661775129:android:f4ea9c120bb911b7511388',
    messagingSenderId: '228661775129',
    projectId: 'private-chat-f61e7',
    storageBucket: 'private-chat-f61e7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1qQyRDSSVm5CojVSoVVa394WjuMGcZyg',
    appId: '1:228661775129:ios:767225293260c355511388',
    messagingSenderId: '228661775129',
    projectId: 'private-chat-f61e7',
    storageBucket: 'private-chat-f61e7.appspot.com',
    iosClientId: '228661775129-4vfcnf2bflu2jjjeimrpqr916s2ruvvt.apps.googleusercontent.com',
    iosBundleId: 'com.example.privateChat',
  );
}
