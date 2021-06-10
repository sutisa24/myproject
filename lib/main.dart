import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sermsuk/pages/login.dart';

main()=>runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(title: 'SERMSUK',debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}