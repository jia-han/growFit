import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front_end/screens/Home.dart';
import 'package:front_end/screens/SignIn.dart';
import 'package:front_end/reusable_widgets/reusable_widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SignUpHome());
  }
}

class SignUpHome extends StatefulWidget {
  SignUpHome({Key? key}) : super(key: key);

  @override
  State<SignUpHome> createState() => _SignUpHomeState();
}

class _SignUpHomeState extends State<SignUpHome> {
  TextEditingController usernameCtrl = TextEditingController();

  TextEditingController emailCtrl = TextEditingController();

  TextEditingController pwCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.amber[200],
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Pangolin',
                      fontSize: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Column(children: [
                    reusableTextField(
                        'Enter Email', Icons.email_outlined, false, emailCtrl),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                        'Enter Password', Icons.lock_outlined, true, pwCtrl),
                    const SizedBox(
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
                            'Treats': 0,
                            'ClaimedReward': false,
                            'TreatsFed': 0,
                            'priceList': {
                              'item1': '250',
                              'item2': '250',
                              'item3': '250'
                            }
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                        user: user,
                                      )));
                        },
                      ).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $error')));
                      });
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: const Text('Sign in'),
                      )
                    ])
                  ]),
                ])));
  }
}
