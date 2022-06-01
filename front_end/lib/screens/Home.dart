import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
              Align(alignment: Alignment.center, child: Text('0')),
              IconButton(icon: Image.asset('assets/images/treat.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('0')),
            ]
          ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Image.asset('assets/images/shop_icon.png', width: 24, height: 24), label: 'shop'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Image.asset('assets/images/gallery_icon.png', width: 24, height: 24), label: 'gallery')
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
      content: Column(children: [Text('Steps Taken: '), Text('Time Exercised: ')],),
      actions: <Widget>[TextButton(child: Text('Back'), onPressed: () { Navigator.of(context).pop();},)],
    );
  });
}