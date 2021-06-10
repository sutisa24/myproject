import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sermsuk/pages/my_service.dart';
import 'package:sermsuk/pages/register.dart';
import 'package:sermsuk/utility/nornal_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;
  bool redEye = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  Future<Null> checkStatus() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MyService(),
              ),
              (route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('images/wall.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLogo(),
                buildAppName(),
                buildUser(),
                buildPassword(), 
                buildButtonLogin(),
                buildResgister(),
                buildForgotpassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildButtonLogin() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          if (email == null ||
              email.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'Please fill out all fields.');
          } else {
            checkLogin();
          }
        },
        child: Text('LOG IN'),
      ),
    );
  }

  Future<Null> checkLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MyService(),
              ),
              (route) => false))
          .catchError((error) {
        normalDialog(context, error.message);
      });
    });
  }

  TextButton buildForgotpassword() => TextButton(
        
          onPressed: () async {
            email = null;
            showDialog(
              context: context,

              builder: (context) => SimpleDialog(
                title: ListTile(
                  leading: Image(
                    image: AssetImage('images/logologin.png'),
                  ),
                  title: Text('Forgot Password ?'),
                  subtitle: Text('Enter the email that you use to sign up your account.'),
                ),
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      onChanged: (value) => email = value.trim(),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (email?.isEmpty ?? true) {
                        normalDialog(context, 'Enter your email.');
                      } else {
                        await Firebase.initializeApp().then((value) async {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email)
                              .then((value) => normalDialog(context,
                                  'Check your email.We have sent thee password reset to your email.'))
                              .catchError((onError) {
                            normalDialog(context, onError.message);
                          });
                        });
                      }
                    },
                    child: Text('Send'),
                  )
                ],
              ),
            );
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.grey),
          
        ),
      );

  Widget buildResgister() => Container(
    width: 300,
      child: OutlineButton(borderSide: BorderSide(width: 1,color: Colors.blue),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Register(),
              )),
          child: Text('Sign Up'),
        ),
  );

  Container buildUser() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextField(
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          hintText: 'Email',
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

  Container buildPassword() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: redEye,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  redEye = !redEye;
                });
              }),
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

  Container buildAppName() => Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: Text(
          'LOG IN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Container buildLogo() {
    return Container(
      width: 120,
      child: Image.asset('images/logologin.png'),
    );
  }
}
