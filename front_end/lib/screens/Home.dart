import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:front_end/main.dart';
import 'package:intl/intl.dart';
import 'package:front_end/screens/Shop.dart';
import 'package:front_end/screens/Gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Home extends StatefulWidget {

  final int treatCount;

  final int money;
  final List<String> priceList;
  final bool claimedReward;
  final int treatsFed;
  const Home({Key? key, required this.treatCount, required this.money, required this.priceList, required this.claimedReward, required this.treatsFed}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  late int treatCount = widget.treatCount;
  late int money = widget.money;
  late List<String> priceList = widget.priceList;
  late bool claimedReward = widget.claimedReward;
  late int treatsFed = widget.treatsFed;
  late int noOfSteps;
  late int itemEquipped;
  List<HealthDataPoint> _healthDataList = [];
  HealthFactory health = HealthFactory();

  @override
  initState() {
    fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.yellow[100],
          appBar: AppBar(
            leading: IconButton(icon: Image.asset('assets/images/health.png'),
                onPressed: () {fetchStepData(); selectHealth(context, noOfSteps); }),
            backgroundColor: Colors.brown,
            actions:<Widget>[
              IconButton(icon: Icon(Icons.power_settings_new), onPressed: () {showDialog(context: context, builder: (context) => AlertDialog(
                title: Text('Sign out?'),
                actions: [
                  //TODO: sign out button
                  ElevatedButton(onPressed: () {signOut();}, child: Text('Sign Out'),),
                ],
              ));},),
              IconButton(icon: Image.asset('assets/images/coin.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('$money')),
              IconButton(icon: Image.asset('assets/images/treat.png'), onPressed: () {} ),
              Align(alignment: Alignment.center, child: Text('$treatCount')),
            ]
          ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/shop_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Shop(treatCount: treatCount, money: money, priceList: priceList, claimedReward: claimedReward, treatsFed: 0,)));},), label: 'shop'),
            BottomNavigationBarItem(icon: IconButton(icon:Icon(Icons.home, color: Colors.amber[800]), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(treatCount: treatCount, money: money, priceList: priceList, claimedReward: claimedReward,treatsFed: treatsFed,)));},), label: 'home'),
            BottomNavigationBarItem(icon: IconButton(icon:Image.asset('assets/images/gallery_icon.png', width: 24, height: 24), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gallery(treatCount: treatCount, money: money, priceList: priceList, claimedReward: claimedReward, treatsFed: 0,)));},), label: 'gallery'),
        ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container( padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
                child: Align(alignment: Alignment.center,child: Image.asset('assets/images/pet.png'))),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (ItemEquipped() == 1)
                    Image.asset('assets/images/ball_1.png'),
                  if (ItemEquipped() == 2)
                    Image.asset('assets/images/ball_2.png'),
                  if (ItemEquipped() == 3)
                    Image.asset('assets/images/ball_3.png'),
                  // FlatButton is depreciated
                  TextButton( onPressed: () {
                    setState(() {
                      treatCount--;
                      treatsFed++;
                    });
                  },
                 child: Image.asset('assets/images/treat_bowl.png'))
                ]
              ),
            ),
            SizedBox(height: 30),

          ],
        ),
        ),
    );
  }

  int ItemEquipped() {
    for (int k = 1; k < 4; k++) {
      if (priceList[k] == 'EQUIPPED') {
        return k;
      }
    }
    return 0;
  }
  Widget petImage() {
    return Image.asset('assets/images/pet.png');
  }
  Future fetchData() async {
    final types = [
      HealthDataType.STEPS,
    ];

    final permissions = [
      HealthDataAccess.READ,
    ];

    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days:5));
    bool requested = await health.requestAuthorization(types,permissions: permissions);
    print('requested: $requested');
    await Permission.activityRecognition.request();

    if (requested) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(yesterday, now, types);
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes");
      }
    } else {
      print ("Authorization not granted");
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
    await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Align(alignment: Alignment.center, child: Text(DateFormat('EEE, M/d/y').format(DateTime.now()))),
        content: Column(children: [Text('Steps Taken: $noOfSteps/300'),
          TextButton(onPressed:  () {
            if (noOfSteps >= 300 && claimedReward == false) {
              setState(() {
                claimedReward = true;
                money = money + 50;
              });
            }
          }, child: Text('Get Daily Reward')),
          Text('Time Exercised: ')], mainAxisSize: MainAxisSize.min,),
        actions: <Widget>[TextButton(child: Text('Back'), onPressed: () { Navigator.of(context).pop();},)],
      );
    });
  }
}

signOut() async {
  await FirebaseAuth.instance.signOut().then((value) {
    runApp(new MaterialApp(home: new MyApp()));
  },);
}
