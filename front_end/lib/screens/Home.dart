import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: Image.asset('assets/images/health.png'),
            backgroundColor: Colors.brown, 
            actions:<Widget>[
              IconButton(icon: Icon(Icons.money, color: Colors.white), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('0')),
              IconButton(icon: Icon(Icons.emoji_food_beverage, color: Colors.white), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('0')),
            ]
          ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'shop'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.picture_in_picture), label: 'gallery')
        ],
        )
        ),
    );
  }
}