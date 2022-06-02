import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Shop.dart';
import 'package:front_end/screens/Gallery.dart';


class Home extends StatefulWidget {
  final int treatCount;
  const Home({Key? key, required this.treatCount}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late int treatCount = widget.treatCount;

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
            BottomNavigationBarItem(icon: IconButton(icon:Icon(Icons.home, color: Colors.amber[800]), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(treatCount: treatCount,)));},), label: 'home'),
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/gallery_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gallery(treatCount: treatCount,)));},), label: 'gallery'),
        ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container( padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0.0),
                child: Align(alignment: Alignment.center,child: Image.asset('assets/images/pet.png'))),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton( onPressed: () {
                    setState(() {
                      treatCount--;
                    });
                  }, padding: EdgeInsets.all(0)
                  , child: Image.asset('assets/images/treat_bowl.png'))
                ]
              ),
            ),
            SizedBox(height: 30)
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