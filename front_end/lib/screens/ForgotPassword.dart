import 'package:flutter/material.dart';
import 'package:front_end/screens/SignIn.dart';


class ForgotPassword extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: ForgotPasswordHome()
    );
  }
}

class ForgotPasswordHome extends StatelessWidget {
  const ForgotPasswordHome({Key? key}) : super(key: key);

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
                    'Reset Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Form(
                    child: Column(
                        children: [
                          TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              )
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                              ),
                              child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));},
                            child: Text('Back'),
                          )
                        ]
                    ),

                  )
                ]
            )
        )
    );
  }
}


