import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Shop.dart';
import 'package:front_end/screens/Home.dart';
import 'package:health/health.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

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
  List<String> priceList = ['', '', '', ''];
  HealthFactory health = HealthFactory();
  late int noOfSteps;
  int money = 0;
  late Image image;
  int treat = 0;
  bool claimedReward = true;
  int treatsFed = 0;
  List<HealthDataPoint> _healthDataList = [];
  Map<String, dynamic> data = Map();
  bool isImagePresent = false;
  ScreenshotController screenshotController = ScreenshotController();

  Future fetchDocData() async {
    print(user.toString());
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((doc) {
      print(doc.data());
      data = doc.data()!;
      treat = data['Treats'];
      money = data['Money'];
      claimedReward = data['ClaimedReward'];
      priceList = data['priceList'];
      print(priceList);
    });
  }

  @override
  initState() {
    _loadImage().whenComplete(() {
      setState(() {});
    });
    super.initState();

    fetchDocData().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadImage();
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
              Screenshot(
                controller: screenshotController,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange[200],
                        border: Border.all(color: Colors.deepOrangeAccent.shade100,
                        width: 3)),
                    height: 300,
                    width: 250,
                    child: Column(children: <Widget>[
                      Expanded(
                        child: isImagePresent != false
                            ? image
                            : SizedBox(width: 30, height: 30),
                      ),
                    ])),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    /**
                    IconButton(
                        icon: Icon(Icons.arrow_left, size: 100),
                        color: Colors.brown,
                        onPressed: () {}), **/
                    TextButton(

                        child: Text('Save to Gallery', style: TextStyle(fontFamily: 'Pangolin')),
                        style: TextButton.styleFrom(
                          primary: Colors.brown,
                            backgroundColor: Colors.yellow[200],
                            side: BorderSide(color: Colors.orangeAccent, width: 1.5),
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                        ),
                        onPressed: () async {
                          final image = await screenshotController.capture();

                          await saveImage(image!)
                              .whenComplete(() => AlertDialog(
                                  title: Text('Saved Successfully!')))
                              .catchError((error) =>
                                  AlertDialog(title: Text('Error: $error')));

                          await Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Image has been saved!'),
                            )
                          );
                        }),
                    TextButton(
                        child: Text('Share to ...', style: TextStyle(fontFamily: 'Pangolin')),
                        style: TextButton.styleFrom(
                            primary: Colors.brown,
                            backgroundColor: Colors.yellow[200],
                            side: BorderSide(color: Colors.orangeAccent, width: 1.5),
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                        ),
                        onPressed: () async {
                          final directory =
                              (await getApplicationDocumentsDirectory()).path;
                          String fileName = 'gallery.png';
                          final image = await screenshotController.capture();
                          shareFunc(image!);
                        }),
                    /**
                    IconButton(
                        icon: Icon(Icons.arrow_right, size: 100),
                        color: Colors.brown,
                        onPressed: () {}), **/
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
            backgroundColor: Colors.brown[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            title: Align(
                alignment: Alignment.center,
                child: Text(DateFormat('EEE, M/d/y').format(DateTime.now()), style: TextStyle(fontFamily: 'Pangolin'),),),
            content: Column(
              children: [
                Text('Steps Taken: $noOfSteps/5000', style: TextStyle(fontFamily: 'Pangolin') ),
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
                    child: Text('Get Daily Reward', style: TextStyle(color: Colors.deepOrange,fontFamily: 'Pangolin'))),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Back', style: TextStyle(color: Colors.deepOrange,fontFamily: 'Pangolin')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<String> get imagePath async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    return '$directory/pet.png';
  }

  Future<void> _loadImage() async {
    final path = await imagePath;
    final _doesTheImageExist = File('${path}/pet.png').existsSync();
    //print(_doesTheImageExist);
    if (_doesTheImageExist == true) {
      setState(() {
        image = Image.file(File("${path}/pet.png"));
        isImagePresent = true;
      });
    } else {
      setState(() {
        //image = null;
        isImagePresent = false;
      });
    }
  }

  Future shareFunc(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/gallery.png');
    image.writeAsBytes(bytes);

    await Share.shareFiles([image.path]);
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final fileName = 'growfit_${DateTime.now()}';
    final saved = await ImageGallerySaver.saveImage(bytes, name: fileName);

    return saved['filePath'];
  }
}

