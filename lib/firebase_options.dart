// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCifK5Q12tLwFS0km4y-j5rsDrwFtGtB98',
    appId: '1:917225693702:web:861c1e9c5020388ada9987',
    messagingSenderId: '917225693702',
    projectId: 'quizapp-64ccd',
    authDomain: 'quizapp-64ccd.firebaseapp.com',
    storageBucket: 'quizapp-64ccd.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-3bU4KCY7AZGGYm4sjzPc_Zo7tHhrZBk',
    appId: '1:917225693702:android:a7ad99823b8fa085da9987',
    messagingSenderId: '917225693702',
    projectId: 'quizapp-64ccd',
    storageBucket: 'quizapp-64ccd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEVXXwaK386iTQW4f4zTr084Roa289fHc',
    appId: '1:917225693702:ios:82381648504212bada9987',
    messagingSenderId: '917225693702',
    projectId: 'quizapp-64ccd',
    storageBucket: 'quizapp-64ccd.firebasestorage.app',
    iosBundleId: 'com.example.quizApp',
  );
}
