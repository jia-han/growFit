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
        return macos;
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
    apiKey: 'AIzaSyDVcNb-Yg5tg16hWCATao3cNjsFw-tHIj8',
    appId: '1:213386640711:web:d884a3224f805b22aba062',
    messagingSenderId: '213386640711',
    projectId: 'growfit-dbcb0',
    authDomain: 'growfit-dbcb0.firebaseapp.com',
    storageBucket: 'growfit-dbcb0.appspot.com',
    measurementId: 'G-EG039CNCGD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7B0eL1QYB1SCMTv7NU5TE8pW6hk8pYTs',
    appId: '1:213386640711:android:78104fe346394824aba062',
    messagingSenderId: '213386640711',
    projectId: 'growfit-dbcb0',
    storageBucket: 'growfit-dbcb0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKoTplzgCKpVieAAxL7pL91mZpgycf2bk',
    appId: '1:213386640711:ios:4bc2b2f0aec3f6d8aba062',
    messagingSenderId: '213386640711',
    projectId: 'growfit-dbcb0',
    storageBucket: 'growfit-dbcb0.appspot.com',
    iosClientId: '213386640711-hnkpj8mg2ctrd9575ba3pmd8bh9gh5ds.apps.googleusercontent.com',
    iosBundleId: 'com.example.frontEnd',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBKoTplzgCKpVieAAxL7pL91mZpgycf2bk',
    appId: '1:213386640711:ios:4bc2b2f0aec3f6d8aba062',
    messagingSenderId: '213386640711',
    projectId: 'growfit-dbcb0',
    storageBucket: 'growfit-dbcb0.appspot.com',
    iosClientId: '213386640711-hnkpj8mg2ctrd9575ba3pmd8bh9gh5ds.apps.googleusercontent.com',
    iosBundleId: 'com.example.frontEnd',
  );
}
