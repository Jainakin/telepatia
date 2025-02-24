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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJS_pn--eBdp4CiyFbh9q4A_BgXDp2P-g',
    appId: '1:643872433733:android:cc9c77d62d3b065caae52c',
    messagingSenderId: '643872433733',
    projectId: 'telepatia-f6ba8',
    storageBucket: 'telepatia-f6ba8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0SebWMo9foBDWdrSzz18iWcoT3GrzCcE',
    appId: '1:643872433733:ios:e8e4e6f91af4fc6faae52c',
    messagingSenderId: '643872433733',
    projectId: 'telepatia-f6ba8',
    storageBucket: 'telepatia-f6ba8.firebasestorage.app',
    iosClientId: '643872433733-lhtv4gk7aut64mt2vagnjfnfqk1ikl5v.apps.googleusercontent.com',
    iosBundleId: 'com.example.telepatiadev',
  );
}
