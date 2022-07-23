import 'package:flutter/material.dart';
import 'package:front_end/screens/ForgotPassword.dart';
import 'package:front_end/screens/Home.dart';
import 'package:front_end/screens/SignUp.dart';
import 'package:front_end/reusable_widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SignInHome());
  }
}

class SignInHome extends StatefulWidget {
  SignInHome({Key? key}) : super(key: key);

  @override
  State<SignInHome> createState() => _SignInHomeState();
}

class _SignInHomeState extends State<SignInHome> {
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
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Pangolin',
                    fontSize: 50,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                reusableTextField(
                    'Enter Email', Icons.email_outlined, false, emailCtrl),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    'Enter Password', Icons.lock_outline, true, pwCtrl),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: const Text('Forgot password?')),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailCtrl.text, password: pwCtrl.text)
                      .then((value) {
                    User? user = value.user;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(
                                  user: user,
                                )));
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Error: $error')));
                  });
                }),
                const SizedBox(
                  height: 20,
                ),
                createAcc(context, SignUp()),
              ]),
        ));
  }
}
