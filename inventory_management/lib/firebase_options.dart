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
    apiKey: 'AIzaSyDEPNpuXgzRFQyKP6JXva6oDBF9ZlsP9XY',
    appId: '1:1099436874819:web:1e356eec1fb0bcfe19c8f6',
    messagingSenderId: '1099436874819',
    projectId: 'inventory-management-2c8f0',
    authDomain: 'inventory-management-2c8f0.firebaseapp.com',
    storageBucket: 'inventory-management-2c8f0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkSeGvNgAZSbJ9n_7GkNY4hXT4o8YV5no',
    appId: '1:1099436874819:android:d8e602a5b77d5c7619c8f6',
    messagingSenderId: '1099436874819',
    projectId: 'inventory-management-2c8f0',
    storageBucket: 'inventory-management-2c8f0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAS6lZYODeWE-AFig99MrY4NU7bCuVUAz4',
    appId: '1:1099436874819:ios:cef7645447dd1cc419c8f6',
    messagingSenderId: '1099436874819',
    projectId: 'inventory-management-2c8f0',
    storageBucket: 'inventory-management-2c8f0.appspot.com',
    iosClientId: '1099436874819-5am5bokbol45kuqi1e27c8nb5p9ps5db.apps.googleusercontent.com',
    iosBundleId: 'com.example.inventoryManagement',
  );
}