import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:front_end/screens/Home.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_end/screens/SignIn.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  var db = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot) {
        if(!snapshot.hasData) {
          return SignIn();
        } else {
          User? user = snapshot.data;
          return Home(user: user,);
        }
      });
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  FirebaseMessaging.onMessageOpenedApp.listen((message) {return main();});
}