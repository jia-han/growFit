import 'dart:collection';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front_end/main.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:front_end/reusable_widgets/reusable_widgets.dart';

class Home extends StatefulWidget {
  final User? user;
  const Home({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseMessaging messaging;
  late User? user = widget.user;
  LinkedHashMap<String, dynamic> priceList = LinkedHashMap();
  late int noOfSteps;
  late int itemEquipped;
  int treat = 0;
  late int money = 0;
  bool claimedReward = true;
  int treatsFed = 0;
  List<HealthDataPoint> _healthDataList = [];
  HealthFactory health = HealthFactory();
  Map<String, dynamic> data = {};
  ScreenshotController screenshotController = ScreenshotController();
  late String fileName;
  late String path;

  @override
  initState() {
    super.initState();
    fetchDocData().whenComplete(() {
      setState(() {});
    });
  }

  Future<String> get imagePath async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    return directory;
  }

  Future screenshotFunc() async {
    final imageDirectory = await imagePath;
    fileName = '${DateTime.now()} pet.png';
    await screenshotController.captureAndSave(imageDirectory,
        fileName: fileName);
  }

  Future fetchDocData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((doc) {
      data = doc.data()!;
      treat = data['Treats'];
      money = data['Money'];
      treatsFed = data['TreatsFed'];
      claimedReward = data['ClaimedReward'];
      priceList = data['priceList'];
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
                icon: const Icon(Icons.power_settings_new),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.brown[100],
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            title: const Text('Sign out?',
                                style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontFamily: 'Pangolin')),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  signOut();
                                },
                                child: const Text('Sign Out',
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontFamily: 'Pangolin')),
                              ),
                            ],
                          ));
                },
              ),
              IconButton(
                icon: Image.asset('assets/images/screenshot.png'),
                onPressed: () {
                  screenshotFunc();
                },
              ),
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
        body: Screenshot(
          controller: screenshotController,
          child: Stack(
            alignment: Alignment.bottomRight,
            fit: StackFit.loose,
            children: [
              Row(
                children: [
                  IconButton(
                    alignment: Alignment.topLeft,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.cake_outlined,
                      color: Colors.brown,
                    ),
                  ),
                  Text('Level ${treatsFed ~/ 10}',
                      style: const TextStyle(
                          fontFamily: 'Pangolin',
                          fontSize: 20,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              petImage(),
              itemImage(),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.fromLTRB(200, 250, 30, 50),
                child: TextButton(
                    onPressed: () {
                      var docUser = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid);
                      if (treat > 0) {
                        setState(() {
                          treat--;
                          treatsFed++;
                        });
                        docUser.update({
                          'Treats': treat,
                          'TreatsFed': treatsFed,
                        });
                      }
                    },
                    child: Image.asset('assets/images/treat_bowl.png')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container itemImage() {
    int itemEquipped() {
      for (int k = 1; k < 4; k++) {
        if (priceList['item$k'] == 'EQUIPPED') {
          return k;
        }
      }
      return 0;
    }

    String getString() {
      switch (itemEquipped()) {
        case 1:
          return 'assets/images/baseball.png';
        case 2:
          return 'assets/images/tennis_ball.png';
        case 3:
          return 'assets/images/mouse_toy.png';
      }
      return '';
    }
    Widget image(string) {
        if (string == '') {
          return const SizedBox();
        } else {
          return Image.asset(string);
        }
    }
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.fromLTRB(45, 250, 275, 60),
      child: image(getString()),
    );
  }

  Widget petImage() {
    double padding = -0.4286 * treatsFed + 80;
    if (padding < 20) {
      padding = 20;
    }
    if (padding > 80) {
      padding = 80;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(padding, 60, padding, 50),
      child: Image.asset('assets/images/pet.png'),
    );
  }

  Future fetchData() async {
    final types = [
      HealthDataType.STEPS,
    ];

    final permissions = [
      HealthDataAccess.READ,
    ];

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 5));
    bool requested =
        await health.requestAuthorization(types, permissions: permissions);
    await Permission.activityRecognition.request();

    if (requested) {
      try {
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(yesterday, now, types);
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error in getting health data')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authorization not granted')));
    }
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

signOut() async {
  await FirebaseAuth.instance.signOut().then(
    (value) {
      runApp(MyApp());
    },
  );
}

