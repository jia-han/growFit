import 'package:flutter/material.dart';


class SignIn extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: SignInHome()
    );
  }
}

class SignInHome extends StatelessWidget {
  const SignInHome({Key? key}) : super(key: key);

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
                          TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: 'Enter your password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              )
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text('Forgot password?')
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                              ),
                              child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No account yet?'),
                                TextButton(
                                  onPressed: () {},
                                  child: Text('Create an account'),
                                )
                              ]
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


