import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sermsuk/models/user_model.dart';
import 'package:sermsuk/utility/nornal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name, surname, phone, email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an account'),
        backgroundColor: Colors.cyanAccent[400],

      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildName(),
              buildSurName(),
              buildPhone(),
              buildEmail(),
              buildPassword(),
              buildButtonResgister()
            ],
          ),
        ),
      ),
    );
  }

  Container buildButtonResgister() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: 200,
      child: OutlinedButton(
        onPressed: () {
          print(
              'name = $name,surname = $surname,phone =$phone,email =$email,password =$password');
          if (name == null ||
              name.isEmpty ||
              surname == null ||
              surname.isEmpty ||
              phone == null ||
              phone.isEmpty ||
              email == null ||
              email.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'Please fill your information completely.');
          } else {
            registerAndInsertUser();
          }
        },
        child: Text('Create account'),
      ),
    );
  }

  Future<Null> registerAndInsertUser() async {
    await Firebase.initializeApp().then((value) async {
      print('Initialize Success');

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String uid = value.user.uid;
        print('Resgister Success uid ==> $uid');

        UserModel model =
            UserModel(name: name, surname: surname, phone: phone, email: email, avatar: '');
        Map<String, dynamic> data = model.toJson();

        await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .set(data)
            .then((value) => Navigator.pop(context));
      }).catchError((error) {
        normalDialog(context, error.message);
      });
    });
  }

  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          hintText: 'First Name',
          prefixIcon: Icon(Icons.account_circle),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Container buildSurName() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextField(
        onChanged: (value) => surname = value.trim(),
        decoration: InputDecoration(
          hintText: 'Last Name',
          prefixIcon: Icon(Icons.group),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Container buildPhone() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextField(
        onChanged: (value) => phone = value.trim(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Mobile Number',
          prefixIcon: Icon(Icons.phone),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Container buildEmail() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextField(
        onChanged: (value) => email = value.trim(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: Icon(Icons.email),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: Icon(Icons.lock),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
