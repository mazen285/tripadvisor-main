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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDH9XEZt_VBbhwrIVAC2AgFPZWEDF3slb0',
    appId: '1:548736098366:web:7bc74ee93883b2d3a5f16f',
    messagingSenderId: '548736098366',
    projectId: 'tripadvisor-c446c',
    authDomain: 'tripadvisor-c446c.firebaseapp.com',
    storageBucket: 'tripadvisor-c446c.firebasestorage.app',
    measurementId: 'G-CSZWCVV30E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkhx3rqfk6tq7GrEjeWaB-z4tyn1zrh0I',
    appId: '1:548736098366:android:a31821f081c771aba5f16f',
    messagingSenderId: '548736098366',
    projectId: 'tripadvisor-c446c',
    storageBucket: 'tripadvisor-c446c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClZ6CSjvsgv-FCCoEDvcKRCSxMu5GYYZ0',
    appId: '1:548736098366:ios:f80c25a0b4c17f85a5f16f',
    messagingSenderId: '548736098366',
    projectId: 'tripadvisor-c446c',
    storageBucket: 'tripadvisor-c446c.firebasestorage.app',
    iosClientId:
        '548736098366-piurcsir8iv6jkj9p5j2cib08i89oaav.apps.googleusercontent.com',
    iosBundleId: 'com.example.tripadvisor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClZ6CSjvsgv-FCCoEDvcKRCSxMu5GYYZ0',
    appId: '1:548736098366:ios:f80c25a0b4c17f85a5f16f',
    messagingSenderId: '548736098366',
    projectId: 'tripadvisor-c446c',
    storageBucket: 'tripadvisor-c446c.firebasestorage.app',
    iosClientId:
        '548736098366-piurcsir8iv6jkj9p5j2cib08i89oaav.apps.googleusercontent.com',
    iosBundleId: 'com.example.tripadvisor',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDH9XEZt_VBbhwrIVAC2AgFPZWEDF3slb0',
    appId: '1:548736098366:web:d73e44e96405f36fa5f16f',
    messagingSenderId: '548736098366',
    projectId: 'tripadvisor-c446c',
    authDomain: 'tripadvisor-c446c.firebaseapp.com',
    storageBucket: 'tripadvisor-c446c.firebasestorage.app',
    measurementId: 'G-XY32WN3GYX',
  );
}
