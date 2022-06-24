import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Home.dart';
import 'package:front_end/screens/Gallery.dart';
import 'package:health/health.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shop extends StatefulWidget {
  final User? user;
  final List<String> priceList;
  const Shop({
    Key? key,
    required this.user,
    required this.priceList,
  }) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  late User? user =  widget.user;
  late List<String> priceList = <String>[];
  int treat = 0;
  HealthFactory health = HealthFactory();
  late int noOfSteps;
  Map<String,dynamic> data = Map();
  int money = 0;
  bool claimedReward = false;

  Future fetchDocData() async {
    print(user.toString());
    var userData = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get().then(
            (doc) {
          print(doc.data());
          data = doc.data()!;
          treat = data['Treats'];
          money = data['Money'];
          claimedReward = data['ClaimedReward'];
        }
    );



  }
  @override
  initState() {

    super.initState();
    fetchDocData().whenComplete((){
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {

    for (var i = 0; i < 4; i++) {
      priceList.add(widget.priceList[i]);
    }
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
              Align(alignment: Alignment.center, child: Text('$treat')),
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
                                  priceList: priceList,
                                )));
                  },
                ),
                label: 'shop'),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(
                                  user: user,
                                  priceList: priceList,
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
                                  priceList: priceList,
                                )));
                  },
                ),
                label: 'gallery'),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      height: 120,
                      width: 120,
                      color: Colors.amber[200],
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Image.asset('assets/images/treatbag.png')),
                        ElevatedButton(
                          onPressed: () {
                            if (money - 50 >= 0) {
                              setState(() {
                                money = money - 50;
                                treat++;
                              });


                            }
                            var docUser = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user?.uid);

                            docUser.update({
                              'Treats' : treat,
                              'Money' : money
                            });

                          },
                          child: Text('50'),
                        )
                      ])),
                  Container(
                      height: 120,
                      width: 120,
                      color: Colors.amber[200],
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset('assets/images/ball_1.png'),
                        )),
                        ElevatedButton(
                          onPressed: () {
                            sellStuff(1);
                          },
                          child: Text('${priceList[1]}'),
                        ),
                      ]))
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      height: 120,
                      width: 120,
                      color: Colors.amber[200],
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset('assets/images/ball_2.png'),
                        )),
                        ElevatedButton(
                          onPressed: () {
                            sellStuff(2);
                          },
                          child: Text('${priceList[2]}'),
                        ),
                      ])),
                  Container(
                      height: 120,
                      width: 120,
                      color: Colors.amber[200],
                      child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset('assets/images/ball_3.png'),
                            )),
                            ElevatedButton(
                              onPressed: () {
                                sellStuff(3);
                              },
                              child: Text('${priceList[3]}'),
                            ),
                          ]))
                ]),
            Row(children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_left, size: 100),
                  color: Colors.brown,
                  onPressed: () {}),
              SizedBox(width: 240),
              IconButton(
                  icon: Icon(Icons.arrow_right, size: 100),
                  color: Colors.brown,
                  onPressed: () {}),
            ])
          ],
        ),
      ),
    );
  }

  void sellStuff(int i) {
    if (priceList[i] == 'BOUGHT') {
      for (int k = 1; k < 4; k++) {
        if (priceList[k] == 'EQUIPPED') {
          setState(() {
            priceList[k] = 'BOUGHT';
          });
        }
      }
      setState(() {
        priceList[i] = 'EQUIPPED';
      });
      return;
    }

    if (priceList[i] == 'EQUIPPED') {
      setState(() {
        priceList[i] == 'BOUGHT';
      });
      return;
    }
    if (priceList[i] != 'BOUGHT' &&
        priceList[i] != 'EQUIPPED' &&
        (money - 50 >= 0)) {
      setState(() {
        money = money - 50;
        priceList[i] = 'BOUGHT';
      });
      return;
    }

    setState(() {
      priceList[i] == 'BOUGHT';
    });
    var docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid);

    docUser.update({
      'Money' : money
    });
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

                      if (noOfSteps >= 300 && claimedReward == false) {
                        setState(() {
                          claimedReward = true;
                          money = money + 50;

                        });
                        var docUser = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid);

                        docUser.update({
                          'Money' : money,
                          'ClaimedReward' : true 
                        });
                      }

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
