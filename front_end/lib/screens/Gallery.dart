import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Shop.dart';
import 'package:front_end/screens/Home.dart';



class Gallery extends StatelessWidget {
<<<<<<< Updated upstream
  const Gallery({Key? key}) : super(key: key);
=======
  final int treatCount;
  final int money;
  const Gallery({Key? key, required this.treatCount, required this.money}) : super(key: key);

>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Image.asset('assets/images/health.png'), onPressed: () => selectHealth(context) ),
            backgroundColor: Colors.brown, 
            actions:<Widget>[
              IconButton(icon: Image.asset('assets/images/coin.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('$money')),
              IconButton(icon: Image.asset('assets/images/treat.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('0')),
            ]
          ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
<<<<<<< Updated upstream
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/shop_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Shop()));},), label: 'shop'),
            BottomNavigationBarItem(icon: IconButton(icon:Icon(Icons.home), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));},), label: 'home'),
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/gallery_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gallery()));},), label: 'gallery'),
=======
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/shop_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Shop(treatCount: treatCount, money: money)));},), label: 'shop'),
            BottomNavigationBarItem(icon: IconButton(icon:Icon(Icons.home, color: Colors.amber[800]), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(treatCount: treatCount, money: money)));},), label: 'home'),
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/gallery_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gallery(treatCount: treatCount, money: money)));},), label: 'gallery'),
>>>>>>> Stashed changes
        ],
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