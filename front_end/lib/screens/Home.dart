import 'dart:collection';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front_end/main.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Shop.dart';
import 'package:front_end/screens/Gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

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
  Map<String, dynamic> data = Map();
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List _imageFile;
  late String fileName;
  late String path;

  @override
  initState() {
    fetchData();
    super.initState();
    final token = FirebaseMessaging.instance.getToken().then((token) {
      if (token == null) {
        print('sadge');
      } else {
        print('Token: $token');
      }
    }).catchError((err) => print('Error: $err'));
    fetchDocData().whenComplete(() {
      setState(() {});
    });
  }

  Future<String> get imagePath async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    return '$directory/pet.png';
  }


  Future screenshotFunc() async {
    final imageDirectory = await imagePath;
    //fileName = await DateTime.now().microsecondsSinceEpoch as String;
    fileName = 'pet.png';
    await screenshotController.captureAndSave(imageDirectory,
        fileName: fileName);
  }

  Future fetchDocData() async {
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((doc) {
      print(doc.data());
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
                icon: Icon(Icons.screenshot),
                onPressed: () {
                  /**
                  screenshotController
                      .capture(delay: Duration(milliseconds: 10))
                      .then((capturedImage) async {
                    ShowCapturedWidget(context, capturedImage!);
                  }).catchError((onError) {
                    print(onError);
                  });**/

                  screenshotFunc();
                },
              ),
              IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Sign out?'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  signOut();
                                },
                                child: Text('Sign Out'),
                              ),
                            ],
                          ));
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
                    icon: Icon(
                      Icons.cake_outlined,
                      color: Colors.brown,
                    ),
                  ),
                  Text('Level ${treatsFed ~/ 10}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              petImage(),
              if (ItemEquipped() == 1)
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset('assets/images/ball_1.png'),
                  padding: EdgeInsets.fromLTRB(45, 250, 275, 60),
                ),
              if (ItemEquipped() == 2)
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset('assets/images/ball_2.png'),
                  padding: EdgeInsets.fromLTRB(45, 250, 275, 60),
                ),
              if (ItemEquipped() == 3)
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset('assets/images/ball_3.png'),
                  padding: EdgeInsets.fromLTRB(45, 250, 275, 60),
                ),
              Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.fromLTRB(200, 250, 30, 50),
                child: TextButton(
                    onPressed: () {
                      var docUser = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid);
                      if (treat >= 0) {
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

  int ItemEquipped() {
    for (int k = 1; k < 4; k++) {
      if (priceList['item$k'] == 'EQUIPPED') {
        return k;
      }
    }
    return 0;
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
    final yesterday = now.subtract(Duration(days: 5));
    bool requested =
        await health.requestAuthorization(types, permissions: permissions);
    print('requested: $requested');
    await Permission.activityRecognition.request();

    if (requested) {
      try {
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(yesterday, now, types);
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes");
      }
    } else {
      print("Authorization not granted");
    }
    _healthDataList.forEach((x) {
      print("Data point: $x");
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
                    child: Text('Get Daily Reward')),
                //Text('Time Exercised: ')
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

signOut() async {
  await FirebaseAuth.instance.signOut().then(
    (value) {
      runApp(new MaterialApp(home: new MyApp()));
    },
  );
}

Future<dynamic> ShowCapturedWidget(
    BuildContext context, Uint8List capturedImage) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: Text("Captured widget screenshot"),
      ),
      body: Center(
          child: capturedImage != null
              ? Image.memory(capturedImage)
              : Container()),
    ),
  );
}
