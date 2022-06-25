import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Shop.dart';
import 'package:front_end/screens/Home.dart';
import 'package:health/health.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Gallery extends StatefulWidget {
  final User? user;

  const Gallery({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late User? user = widget.user;
  List<String> priceList = ['','','',''];
  HealthFactory health = HealthFactory();
  late int noOfSteps;
  int money = 50;
  int treatCount = 50;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.yellow[100],
          appBar: AppBar(
              leading: IconButton(
                  icon: Image.asset('assets/images/health.png'),
                  onPressed: () {
                    fetchStepData();
                    selectHealth(context, noOfSteps);
                  }),
              backgroundColor: Colors.brown,
              actions: <Widget>[
                IconButton(
                    icon: Image.asset('assets/images/coin.png'),
                    onPressed: () {}),
                Align(alignment: Alignment.center, child: Text('$money')),
                IconButton(
                    icon: Image.asset('assets/images/treat.png'),
                    onPressed: () {}),
                Align(alignment: Alignment.center, child: Text('$treatCount')),
              ]),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
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
                  label: 'shop'),
              BottomNavigationBarItem(
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
                  label: 'home'),
              BottomNavigationBarItem(
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
                  label: 'gallery'),
            ],
          ),
          body: Center(
            child: Column(children: <Widget>[
              SizedBox(height: 100),
              Container(
                  height: 300,
                  width: 250,
                  color: Colors.brown[200],
                  child: Column(children: <Widget>[
                    Image.asset('assets/images/pet.png'),
                    Text(
                      '26/09/22',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'Steps taken:',
                      style: TextStyle(fontSize: 30),
                    ),
                  ])),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_left, size: 100),
                        color: Colors.brown,
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.share, size: 50),
                        color: Colors.brown,
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.arrow_right, size: 100),
                        color: Colors.brown,
                        onPressed: () {}),
                  ])
            ]),
          )),
    );
  }

  Future fetchStepData() async {
    int? steps;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval");
      }
      print('Total number of steps: $steps');

      setState(() {
        noOfSteps = (steps == null) ? 0 : steps;
      });
    } else {
      print("Authorization not granted");
    }
  }

  Future<void> selectHealth(BuildContext context, int noOfSteps) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Align(
                alignment: Alignment.center,
                child: Text(DateFormat('EEE, M/d/y').format(DateTime.now()))),
            content: Column(
              children: [
                Text('Steps Taken: $noOfSteps/5000'),
                TextButton(
                    onPressed: () {
                      /**
            if (noOfSteps >= 300 && claimedReward == false) {
              setState(() {
                claimedReward = true;
                money = money + 50;
              });
            }**/
                    },
                    child: Text('Get Daily Reward')),
                Text('Time Exercised: ')
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
