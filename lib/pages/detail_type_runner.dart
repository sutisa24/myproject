import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  List<String> nameTypes = [
    'กติกาการแข่งขัน 3 กิโลเมตร',
    'กติกาการแข่งขัน 5 กิโลเมตร',
    'กติกาการแข่งขัน 10 กิโลเมตร',
  ];
  List<String> detailType = [
    'ผู้เข้าแข่งขันสามารถเข้าร่วมการวิ่งได้โดยสามารถวิ่งที่ใดก็ได้ ภายในระยะเวลา 1 สัปดาห์ เริ่มตั้งแต่วันที่ 1-7 เมษายน ',
    'ผู้เข้าแข่งขันสามารถเข้าร่วมการวิ่งได้โดยสามารถวิ่งที่ใดก็ได้ ภายในระยะเวลา 1 สัปดาห์ เริ่มตั้งแต่วันที่ 1-7 เมษายน ',
    'ผู้เข้าแข่งขันสามารถเข้าร่วมการวิ่งได้โดยสามารถวิ่งที่ใดก็ได้ ภายในระยะเวลา 1 สัปดาห์ เริ่มตั้งแต่วันที่ 1-7 เมษายน ',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    image = widget.imagePath;
    title = widget.title;
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildRegister(context),
      appBar: AppBar(
        title: Text('ชนิดการแข่งขันแบบ : $title '),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nameTypes[index],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(detailType[index]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ตารางจัดอันดับผู้แข่งขัน ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

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
                print('ยังไม่มี Type');
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) => SimpleDialog(
                        title: ListTile(
                          leading: Image(
                            image: AssetImage('images/logoip.png'),
                          ),
                          title: Text('โปรดเลือก Type'),
                        ),
                        children: [
                          RadioListTile(
                            title: Text('นักวิ่งทั่วไป'),
                            value: 'General',
                            groupValue: type,
                            onChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text('ผู้เข้าแข่งขัน'),
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
                                normalDialog(context, 'โปรดเลือก Type ด้วยค่ะ');
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
                            child: Text('ตกลง'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                moveToGpsRunner(context, model);
              }
            });
          });
        });
      },
      child: Text('สมัครแข่งขันแบบ :$title'),
    );
  }

  void moveToGpsRunner(BuildContext context, UserModel model) {

    
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => GpsRunner(typeRunner: title,status: false,),
        ),
        (route) => false);
  }
}
