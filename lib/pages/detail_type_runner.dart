import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sermsuk/models/runner_model.dart';
import 'package:sermsuk/models/user_model.dart';
import 'package:sermsuk/pages/gps_runner.dart';
import 'package:sermsuk/utility/nornal_dialog.dart';

class DetailTypeRunner extends StatefulWidget {
  final String imagePath;
  final String title;
  final int index;

  DetailTypeRunner({Key key, this.imagePath, this.title, this.index})
      : super(key: key);

  @override
  _DetailTypeRunnerState createState() => _DetailTypeRunnerState();
}

class _DetailTypeRunnerState extends State<DetailTypeRunner> {
  String image, title, type;
  int index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    image = widget.imagePath;
    title = widget.title;
    index = widget.index;

    readData();
  }

  List<String> uidRunners = [];
  List<String> nameRunners = [];
  List<RunnerModel> runnerModels = [];
  List<DateTime> dateTimes = [];
  Map<String, dynamic> nameSurMap = Map();
  int i = 1;
  List<Widget> coins = [
    Image.asset('images/cgold1.png'),
    Image.asset('images/csilver1.png'),
    Image.asset('images/ccopper1.png'),
  ];

  List<String> urlUsers = [];

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('User')
          .snapshots()
          .listen((event) async {
        for (var item in event.docs) {
          String nameRunner =
              '${item.data()['Name']} ${item.data()['Surname']}';
          nameSurMap[item.id] = nameRunner;
          // UserModel userModel = UserModel.fromJson(item.data());
          // urlUsers.add(userModel.avatar);
        }

        /// for

        print('#### title = $title');
        await FirebaseFirestore.instance
            .collection(title)
            .snapshots()
            .listen((event) async {
          print('###### event == ${event.docs}');
          for (var item in event.docs) {
            String dateTimeStr = item.id;
            print('####### dateTimeStr = $dateTimeStr');
            List<String> strings = dateTimeStr.split('-');
            DateTime dateTime = DateTime(
              int.parse(strings[2]),
              int.parse(strings[1]),
              int.parse(strings[0]),
            );
            print('#### datetime ===> $dateTime');
            if (dateTimes.length == 0) {
              dateTimes.add(dateTime);
            } else {
              if (dateTimes[0].isBefore(dateTime)) {
                dateTimes[0] = dateTime;
              }
            }
          } //for
          print('##### การแข่งขันล่าสุด ==> ${dateTimes[0]}');
          String string = dateTimes[0].toString();
          List<String> strings = string.split(' ');

          List<String> dateStrs = strings[0].split('-');
          String dateStr = '${dateStrs[2]}-${dateStrs[1]}-${dateStrs[0]}';
          print('##### dateStrs ===> $dateStr');

          await FirebaseFirestore.instance
              .collection(title)
              .doc(dateStr)
              .collection('runner')
              .orderBy('timerunner')
              .snapshots()
              .listen((event) {
            for (var item in event.docs) {
              findUrlRunner(item.id);
              setState(() {
                nameRunners.add(' ${nameSurMap[item.id]}');
                runnerModels.add(RunnerModel.fromJson(item.data()));
              });
              i++;
            }
          });
        });
      });
    });
  }

  Future<Null> findUrlRunner(String uidRunner) async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(uidRunner)
        .snapshots()
        .listen((event) {
      UserModel userModel = UserModel.fromJson(event.data());
      setState(() {
        urlUsers.add(userModel.avatar);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildRegister(context),
      appBar: AppBar(
        title: Text('Competition : $title '),
        backgroundColor: Colors.cyanAccent[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //buildTitle1(),
            //buildDetail(),
            buildTitle2(),
            buildListView(),
          ],
        ),
      ),
    );
  }

  String printDuration(int sec) {
    Duration duration = Duration(seconds: sec);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinites = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinites:$twoDigitSeconds";
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: nameRunners.length,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: index <= 2
                          ? Center(
                              child: Container(
                                width: 30,
                                child: coins[index],
                              ),
                            )
                          : SizedBox()),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 80,
                      height: 80,
                      child: urlUsers.length == 0
                          ? SizedBox()
                          : CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                urlUsers[index],
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        nameRunners[index],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${printDuration(int.parse(runnerModels[index].timerunner))} ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign:TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTitle2() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          'Competitor ',
          style: TextStyle(
            fontSize: 25,
            color: Colors.lightBlue[900],
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // //Padding buildDetail() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Text(detailType[index]),
  //   );
  // }

  // //Padding buildTitle1() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Text(
  //       nameTypes[index],
  //       style: TextStyle(
  //         fontSize: 18,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  ElevatedButton buildRegister(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        print('############ register Work');
        await Firebase.initializeApp().then((value) async {
          await FirebaseAuth.instance.authStateChanges().listen((event) async {
            String uid = event.uid;
            await FirebaseFirestore.instance
                .collection('User')
                .doc(uid)
                .snapshots()
                .listen((event) {
              UserModel model = UserModel.fromJson(event.data());
              print('###### type ===>> ${model.type}');
              if (model.type == null) {
                print('ยังไม่มีชนิดผู้แข่งขัน');
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) => SimpleDialog(
                        title: ListTile(
                          leading: Image(
                            image: AssetImage('images/logologin.png'),
                          ),
                          title: Text('Please confirm the competition and click "Runner".'),
                        ),
                        children: [
                          // RadioListTile(
                          //   title: Text('General'),
                          //   value: 'General',
                          //   groupValue: type,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       type = value;
                          //     });
                          //   },
                          // ),
                          RadioListTile(
                            title: Text('Runner'),
                            value: 'Sport',
                            groupValue: type,
                            onChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            },
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              if (type == null) {
                                normalDialog(context, 'Please click "Runner"');
                              } else {
                                Map<String, dynamic> data = Map();
                                data['Type'] = type;
                                await FirebaseFirestore.instance
                                    .collection('User')
                                    .doc(uid)
                                    .update(data)
                                    .then((value) =>
                                        moveToGpsRunner(context, model));
                              }
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                checkMatch(model);
              }
            });
          });
        });
      },
      child: Text('Apply for :$title race'),
      style: ElevatedButton.styleFrom(
        primary: Colors.amber[300],
        onPrimary: Colors.white,
        shadowColor: Colors.red,
        elevation: 5,
      ),
    );
  }

  Future<Null> checkMatch(UserModel model) async {
    DateTime dateTimeToday = DateTime.now();
    dateTimeToday = DateTime(dateTimeToday.year, dateTimeToday.month,
        dateTimeToday.day, 0, 0, 0, 0, 0);
    print('#####dateTimeToday = $dateTimeToday#####');

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('match')
          .doc(title)
          .snapshots()
          .listen((event) {
        print('${event.data()['matchdate']}');
        Timestamp timestamp = event.data()['matchdate'];
        DateTime dateTimeMatch = timestamp.toDate();
        print('######datetime = $dateTimeMatch#####');

        if (dateTimeToday.isAfter(dateTimeMatch)) {
          print('แข่งไปแล้ว');
          normalDialog(context, 'Can not apply because the competition has been completed.');
        } else if (dateTimeToday.isBefore(dateTimeMatch)) {
          print('ก่อนแข่งขัน');
          normalDialog(context, 'Can not apply because the competition is not yet due.');
        } else {
          print('วันที่แข่ง');
          moveToGpsRunner(context, model);
        }
      });
    });
  }

  void moveToGpsRunner(BuildContext context, UserModel model) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => GpsRunner(
            typeRunner: title,
            status: false,
          ),
        ),
        (route) => false);
  }
}
