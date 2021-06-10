import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sermsuk/models/runner_model.dart';
import 'package:sermsuk/pages/type_runner.dart';

class ShowListRunner extends StatefulWidget {
  @override
  _ShowListRunnerState createState() => _ShowListRunnerState();
}

class _ShowListRunnerState extends State<ShowListRunner> {
  bool statusLoad = true;
  bool statusData = false; //true => Have Data
  List<RunnerModel> runnerModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid ==>> $uid');
        await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .collection('runner')
            .where(
              'typerunner',
              isEqualTo: 'ทั่วไป',
            )
            .snapshots()
            .listen((event) {
          print('event == ${event.toString()}');
          setState(() {
            statusLoad = false;
          });
          if (event.docs.toString() != '[]') {
            for (var item in event.docs) {
              RunnerModel model = RunnerModel.fromJson(item.data());

              setState(() {
                statusData = true;
                runnerModels.add(model);
              });
            }
          }
        });
      });
    });
  }

  String printDuration(int sec){
        Duration duration = Duration(seconds : sec);
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitMinites = twoDigits(duration.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
        return "${twoDigits(duration.inHours)}:$twoDigitMinites:$twoDigitSeconds";  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My running status'),
        backgroundColor: Colors.cyanAccent[400],
      ),
      body: statusLoad
          ? Center(child: CircularProgressIndicator())
          : statusData
              ? ListView.builder(
                  itemCount: runnerModels.length,
                  itemBuilder: (context, index) => Card(
                    color: index % 2 == 0
                        ? Colors.cyanAccent.shade100
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'ชนิดของการแข่งขัน : ${runnerModels[index].typerunner}',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.blue.shade900,
                          //   ),
                          // ),
                          Text('Date and Time : ${runnerModels[index].daterunner}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Distance : ${runnerModels[index].distance} Km.'),
                              Text(
                                  'Time : ${printDuration(int.parse(runnerModels[index].timerunner))} '),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(child: Text('No running status')),
    );
  }
}
