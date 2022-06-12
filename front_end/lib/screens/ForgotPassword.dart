import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front_end/screens/SignIn.dart';
import 'package:front_end/reusable_widgets/reusable_widgets.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: ForgotPasswordHome());
  }
}

TextEditingController emailCtrl = TextEditingController();

class ForgotPasswordHome extends StatelessWidget {
  ForgotPasswordHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));},
                icon: Icon(Icons.arrow_back),
                color: Colors.black),
                backgroundColor: Colors.transparent,
                elevation: 0,),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.yellow[200],
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  reusableTextField(
                      'Enter Email', Icons.email_outlined, false, emailCtrl),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        resetPassword(context);
                      },
                      child: Text(
                        'Reset Password',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black;
                            }
                            return Colors.white;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30))))),
                ])));
  }
}

Future resetPassword(BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailCtrl.text.trim());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Password Reset Email Sent')));
  } on FirebaseAuthException catch (e) {
    print(e);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${e.message}')));
  }
}
