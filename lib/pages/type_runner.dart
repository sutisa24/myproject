import 'package:flutter/material.dart';

class TypeRunner extends StatefulWidget {
  @override
  _TypeRunnerState createState() => _TypeRunnerState();
}

class _TypeRunnerState extends State<TypeRunner> {
  List<String> images = [
    'images/3k.png',
    'images/5k.png',
    'images/10k.png'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemCount: images.length,
        itemBuilder: (context, index) => Image.asset(images[index]),
      ),
    );
  }
}
