//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front_end/screens/Shop.dart';
import 'firebase_options.dart';
import 'package:front_end/screens/Home.dart';
import 'package:front_end/screens/ForgotPassword.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_end/screens/SignIn.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  var db = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    const providerConfigs = [EmailProviderConfiguration()];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authGate(),
    );
  }
}

class authGate extends StatelessWidget {
  authGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot) {
        if(!snapshot.hasData) {
          return SignIn();
        } else {
          User? user = snapshot.data;
          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .get()
                              .then(
                            (doc) {
                              Map<String,dynamic> data = doc.data()!;
                              return Home(user: user,);
                            },
                          );
                          return SignIn();
        }
      });
  }
}