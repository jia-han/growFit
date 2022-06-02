import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Home.dart';
import 'package:front_end/screens/Gallery.dart';

class Shop extends StatelessWidget {
  final int treatCount;

  const Shop({Key? key,
  required this.treatCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.yellow[100],
        appBar: AppBar(
            leading: IconButton(icon: Image.asset('assets/images/health.png'), onPressed: () => selectHealth(context) ),
            backgroundColor: Colors.brown, 
            actions:<Widget>[
              IconButton(icon: Image.asset('assets/images/coin.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('0')),
              IconButton(icon: Image.asset('assets/images/treat.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('$treatCount')),
            ]
          ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/shop_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Shop(treatCount: treatCount,)));},), label: 'shop'),
            BottomNavigationBarItem(icon: IconButton(icon:Icon(Icons.home), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(treatCount: treatCount,)));},), label: 'home'),
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/gallery_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gallery(treatCount: treatCount,)));},), label: 'gallery'),
        ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  Container(height: 120, width: 120,
                      color: Colors.amber[200],
                      child: Column(
                          children: <Widget>[
                            Expanded(child: Image.asset('assets/images/treatbag.png')),
                            Text('50'),
                          ]
                      )
                  ),
                  Container(height: 120, width: 120,
                      color: Colors.amber[200],
                      child: Column(
                          children: <Widget>[
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset('assets/images/ball_1.png'),
                            )),
                            Text('50'),
                          ]
                      )
                  )
                ]
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  Container(height: 120, width: 120,
                      color: Colors.amber[200],
                      child: Column(
                          children: <Widget>[
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset('assets/images/ball_2.png'),
                            )),
                            Text('50'),
                          ]
                      )
                  ),
                  Container(height: 120, width: 120,
                      color: Colors.amber[200],
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset('assets/images/ball_3.png'),
                            )),
                            Text('50'),
                          ]
                      )
                  )
                ]
            ),
            Row(

                children: <Widget>[
                  IconButton(icon: Icon(Icons.arrow_left, size: 100),
                      color: Colors.brown,
                      onPressed: () {}),
                  SizedBox(width: 240),

                  IconButton(icon: Icon(Icons.arrow_right, size: 100),
                      color: Colors.brown,
                      onPressed: () {}),
                ]
            )
          ],
        ),

      ),
    );
  }
}

Future<void> selectHealth(BuildContext context) async {
  await showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Align(alignment: Alignment.center, child: Text(DateFormat('EEE, M/d/y').format(DateTime.now()))),
      content: Column(children: [Text('Steps Taken: '), Text('Time Exercised: ')], mainAxisSize: MainAxisSize.min,),
      actions: <Widget>[TextButton(child: Text('Back'), onPressed: () { Navigator.of(context).pop();},)],
    );
  });
}