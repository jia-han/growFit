import 'package:flutter/material.dart';
import 'package:front_end/screens/Shop.dart';
import 'package:front_end/screens/Home.dart';
import 'package:front_end/screens/Gallery.dart';

BottomNavigationBarItem shopButton(context, user) {
  return BottomNavigationBarItem(
                icon: IconButton(
                  icon: Image.asset('assets/images/shop_icon.png',
                      width: 24, height: 24),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Shop(
                                  user: user,
                                )));
                  },
                ),
                label: 'shop');
}

BottomNavigationBarItem homeButton(context, user) {
  return BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.home, color: Colors.amber[800]),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(
                                  user: user,
                                )));
                  },
                ),
                label: 'home');
} 

BottomNavigationBarItem galleryButton(context, user) {
  return BottomNavigationBarItem(
                icon: IconButton(
                  icon: Image.asset('assets/images/gallery_icon.png',
                      width: 24, height: 24),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Gallery(
                                  user: user,
                                )));
                  },
                ),
                label: 'gallery');
}



TextField reusableTextField(String text, IconData icon, bool isPWType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPWType,
    enableSuggestions: !isPWType,
    autocorrect: !isPWType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.black.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType:
        isPWType ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(BuildContext context, bool isLogIn, Function onTap) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          child: Text(
            isLogIn ? 'LOG IN' : 'SIGN UP',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black;
                }
                return Colors.white;
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))))));
}

Row createAcc(BuildContext context, Widget screen) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text('No account yet?'),
    TextButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Text('Create an account'),
    )
  ]);
}