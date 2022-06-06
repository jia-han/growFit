import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Shop.dart';
import 'package:front_end/screens/Home.dart';



class Gallery extends StatelessWidget {
  final int treatCount;
  final int money;
  final List<String> priceList;
  const Gallery({Key? key, required this.treatCount, required this.money, required this.priceList}) : super(key: key);


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
              Align(alignment: Alignment.center, child: Text('$money')),
              IconButton(icon: Image.asset('assets/images/treat.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('$treatCount')),
            ]
          ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/shop_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Shop(treatCount: treatCount, money: money, priceList: priceList,)));},), label: 'shop'),
            BottomNavigationBarItem(icon: IconButton(icon:Icon(Icons.home, color: Colors.amber[800]), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(treatCount: treatCount, money: money, priceList: priceList)));},), label: 'home'),
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/gallery_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gallery(treatCount: treatCount, money: money, priceList: priceList)));},), label: 'gallery'),
        ],
        ),
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 100),
                Container(height: 300, width: 250, color: Colors.brown[200],
                child: Column(
                  children: <Widget>[Image.asset('assets/images/pet.png'),
                  Text('26/09/22', style: TextStyle(fontSize: 30),),
                  Text('Steps taken:', style: TextStyle(fontSize: 30),),
                  ]

                )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.arrow_left, size: 100),
                        color: Colors.brown,
                        onPressed: () {}),
                    IconButton(icon: Icon(Icons.share, size: 50),
                        color: Colors.brown,
                        onPressed: () {}),
                    IconButton(icon: Icon(Icons.arrow_right, size: 100),
                        color: Colors.brown,
                        onPressed: () {}),
                  ]
                )

              ]
            ),
          )
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