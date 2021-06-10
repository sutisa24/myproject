import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sermsuk/models/user_model.dart';
import 'package:sermsuk/pages/edit_infor.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  UserModel userModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readInfor();
  }

  Future<Null> readInfor() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid Login ==> $uid');
        await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromJson(event.data());
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null
          ? Text('No Information')
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildAvatar(),
                      buildEditButton(),
                      Card(color: Colors.grey.shade50,
                                              child: Column(mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                                title: Text('First Name '),
                                subtitle: Text('${userModel.name}'),
                                leading: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                              ),
                            ListTile(
                              title: Text('Last Name '),
                              subtitle: Text('${userModel.surname}'),
                              leading: Icon(
                                Icons.group,
                                color: Colors.blue,
                              ),
                            ),
                            ListTile(
                              title: Text('Mobile Number'),
                              subtitle: Text('${userModel.phone}'),
                              leading: Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                            ),
                            ListTile(
                              title: Text('Email '),
                              subtitle: Text('${userModel.email}'),
                              leading: Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  RaisedButton buildEditButton() => RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.amber,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditInfor(
              model: userModel,
            ),
          ),
        ).then((value) => readInfor()),
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: Text(
          'Edit',
          style: TextStyle(color: Colors.white),
        ),
      );

  Container buildAvatar() {
    return Container(
      margin: EdgeInsets.all(20),
      width: 250,
      height: 250,
      child: userModel.avatar == null
          ? Image.asset('images/avatar.png')
          : CircleAvatar(
              backgroundImage: NetworkImage(userModel.avatar),
            ),
    );
  }
}
