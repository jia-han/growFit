import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health/health.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_end/reusable_widgets/reusable_widgets.dart';

class Shop extends StatefulWidget {
  final User? user;
  const Shop({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  late User? user = widget.user;
  LinkedHashMap<String, dynamic> priceList = LinkedHashMap();
  int treat = 0;
  HealthFactory health = HealthFactory();
  late int noOfSteps;
  Map<String, dynamic> data = {};
  int money = 0;
  bool claimedReward = false;

  Future fetchDocData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((doc) {
      data = doc.data()!;
      treat = data['Treats'];
      money = data['Money'];
      claimedReward = data['ClaimedReward'];
      priceList = data['priceList'];
    });
  }

  @override
  initState() {
    super.initState();
    fetchDocData().whenComplete(() {
      setState(() {});
    });
  }

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
              Align(alignment: Alignment.center, child: Text('$treat')),
            ]),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            shopButton(context, user),
            homeButton(context, user),
            galleryButton(context, user),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.amber[200],
                          border: Border.all(
                              color: Colors.deepOrange.shade200, width: 3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Image.asset('assets/images/treatbag.png')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          onPressed: () {
                            if (money >= 10) {
                              setState(() {
                                money = money - 10;
                                treat++;
                              });
                            }
                            var docUser = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user?.uid);

                            docUser.update({'Treats': treat, 'Money': money});
                          },
                          child: const Text('10',
                              style: TextStyle(fontFamily: 'Pangolin')),
                        )
                      ])),
                  Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.amber[200],
                          border: Border.all(
                              color: Colors.deepOrange.shade200, width: 3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset('assets/images/baseball.png'),
                        )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          onPressed: () {
                            sellStuff(1);
                          },
                          child: Text('${priceList['item1']}',
                              style: const TextStyle(fontFamily: 'Pangolin')),
                        ),
                      ]))
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.amber[200],
                          border: Border.all(
                              color: Colors.deepOrange.shade200, width: 3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset('assets/images/tennis_ball.png'),
                        )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          onPressed: () {
                            sellStuff(2);
                          },
                          child: Text('${priceList['item2']}',
                              style: const TextStyle(fontFamily: 'Pangolin')),
                        ),
                      ])),
                  Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.amber[200],
                          border: Border.all(
                              color: Colors.deepOrange.shade200, width: 3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset('assets/images/mouse_toy.png'),
                        )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          onPressed: () {
                            sellStuff(3);
                          },
                          child: Text('${priceList['item3']}',
                              style: const TextStyle(fontFamily: 'Pangolin')),
                        ),
                      ]))
                ]),
          ],
        ),
      ),
    );
  }

  void sellStuff(int i) {
    var docUser = FirebaseFirestore.instance.collection('users').doc(user?.uid);

    if (priceList['item$i'] == 'BOUGHT') {
      print('hello');
      for (int k = 1; k < 4; k++) {
        if (priceList['item$k'] == 'EQUIPPED') {
          setState(() {
            priceList['item$k'] = 'BOUGHT';
          });
        }
      }
      setState(() {
        priceList['item$i'] = 'EQUIPPED';
      });
    }

    else if (priceList['item$i'] == 'EQUIPPED') {
      setState(() {
        priceList['item$i'] = 'BOUGHT';
      });
    }
    else if (priceList['item$i'] != 'BOUGHT' &&
        priceList['item$i'] != 'EQUIPPED' &&
        (money >= 250)) {
      setState(() {
        money = money - 250;
        priceList['item$i'] = 'BOUGHT';
      });
    }

    docUser.update({'Money': money, 'priceList': priceList});
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error in getting number of steps')));
      }

      setState(() {
        noOfSteps = (steps == null) ? 0 : steps;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authorization not granted')));
    }
  }

  Future<void> selectHealth(BuildContext context, int noOfSteps) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.brown[100],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            title: Align(
              alignment: Alignment.center,
              child: Text(
                DateFormat('EEE, M/d/y').format(DateTime.now()),
                style: const TextStyle(fontFamily: 'Pangolin'),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Steps Taken: $noOfSteps/5000',
                    style: const TextStyle(fontFamily: 'Pangolin')),
                TextButton(
                    onPressed: () {
                      if (noOfSteps >= 5000 && claimedReward == false) {
                        setState(() {
                          claimedReward = true;
                          money = money + 50;
                        });
                        var docUser = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid);

                        docUser.update({'Money': money, 'ClaimedReward': true});
                      }
                    },
                    child: const Text('Get Daily Reward',
                        style: TextStyle(
                            color: Colors.deepOrange, fontFamily: 'Pangolin'))),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Back',
                    style: TextStyle(
                        color: Colors.deepOrange, fontFamily: 'Pangolin')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
