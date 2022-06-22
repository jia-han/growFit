import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:front_end/screens/ForgotPassword.dart';
import 'package:front_end/screens/Home.dart';
import 'package:front_end/screens/SignUp.dart';
import 'package:front_end/reusable_widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: SignInHome());
  }
}

class SignInHome extends StatelessWidget {
  SignInHome({Key? key}) : super(key: key);

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController pwCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.yellow[200],
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                reusableTextField(
                    'Enter Username', Icons.email_outlined, false, emailCtrl),
                SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    'Enter Password', Icons.lock_outline, true, pwCtrl),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: Text('Forgot password?')),
                SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailCtrl.text, password: pwCtrl.text)
                      .then((value) {
                    User? user = value.user;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .get()
                        .then(
                      (doc) {
                        Map<String, dynamic> data = doc.data()!;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                    treatCount: data['Treats'],
                                    money: data['Money'],
                                    priceList: ['50', '50', '50', '50'],
                                claimedReward: false,
                                treatsFed: 0,)));
                      },
                    );
                  }).onError((error, stackTrace) {
                    print('Error ${error.toString()}');
                  });
                }),
                SizedBox(
                  height: 20,
                ),
                createAcc(context, SignUp()),
              ]),
        ));
  }
}
