import 'package:flutter/material.dart';

class Shop extends StatelessWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            leading: Image.asset('assets/images/health.png'),
            backgroundColor: Colors.orangeAccent,
            actions:<Widget>[
              IconButton(icon: Image.asset('assets/images/coin.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('0')),
              IconButton(icon: Image.asset('assets/images/treat.png', color: Colors.white), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('0')),
            ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'shop'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.picture_in_picture), label: 'gallery')
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
