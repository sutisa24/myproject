import 'package:flutter/material.dart';
import 'package:sermsuk/pages/login.dart';

main()=>runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'SERMSUK',
      home: Login(),
    );
  }
}