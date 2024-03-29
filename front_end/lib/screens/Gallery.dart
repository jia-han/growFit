import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health/health.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:front_end/reusable_widgets/reusable_widgets.dart';

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
  List images = [];
  int treat = 0;
  bool claimedReward = true;
  int treatsFed = 0;
  Map<String, dynamic> data = {};
  bool isImagePresent = false;
  ScreenshotController screenshotController = ScreenshotController();

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
    _loadImage();
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
          body: Center(
            child: Column(children: <Widget>[
              const SizedBox(height: 100),
              Screenshot(
                  controller: screenshotController,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange[200],
                        border: Border.all(
                            color: Colors.deepOrangeAccent.shade100, width: 3)),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: PageView.builder(
                      controller: PageController(initialPage: 0),
                      itemBuilder: (context, index) {
                        return Image.file(images.elementAt(index));
                      },
                      itemCount: images.length,
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.brown,
                            backgroundColor: Colors.yellow[200],
                            side: const BorderSide(
                                color: Colors.orangeAccent, width: 1.5),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                          final image = await screenshotController.capture();
                          await saveImage(image!);
                        },
                        child: const Text('Save to Gallery',
                            style: TextStyle(fontFamily: 'Pangolin'))),
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.brown,
                            backgroundColor: Colors.yellow[200],
                            side: const BorderSide(
                                color: Colors.orangeAccent, width: 1.5),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                          final image = await screenshotController.capture();
                          shareFunc(image!);
                        },
                        child: const Text('Share to ...',
                            style: TextStyle(fontFamily: 'Pangolin'))),
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

  Future<String> get imagePath async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    //print(directory);
    return directory;
  }

  void _loadImage() async {
    final path = await imagePath;
    setState(() {
      images = Directory(path)
          .listSync()
          .where(
              (element) => element is File && element.path.endsWith('pet.png'))
          .toList();
    });
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
