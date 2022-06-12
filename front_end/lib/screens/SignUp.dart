import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front_end/screens/Home.dart';
import 'package:front_end/screens/SignIn.dart';
import 'package:front_end/reusable_widgets/reusable_widgets.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignUpHome());
  }
}

class SignUpHome extends StatelessWidget {
  SignUpHome({Key? key}) : super(key: key);

  TextEditingController usernameCtrl = TextEditingController();
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
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(children: [
                    reusableTextField(
                        'Enter Username', Icons.person, false, usernameCtrl),
                    SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                        'Enter Email', Icons.email_outlined, false, emailCtrl),
                    SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                        'Enter Password', Icons.lock_outlined, true, pwCtrl),
                    SizedBox(
                      height: 20,
                    ),
                    signInSignUpButton(context, false, () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailCtrl.text, password: pwCtrl.text)
                          .then(
                        (value) {
                          User? user = value.user;
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .set({
                            'Email': emailCtrl.text,
                            'UserName': usernameCtrl.text,
                            'Money': 0,
                            'Treats': 0
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                      treatCount: 0,
                                      money: 0,
                                      priceList: ['50', '50', '50', '50'])));
                        },
                      ).onError((error, stackTrace) {
                        print('Error ${error.toString()}');
                      });
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Text('Sign in'),
                      )
                    ])
                  ]),
                ])));
  }
}
