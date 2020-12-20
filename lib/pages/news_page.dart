import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<String> images = [
    
    'images/Newsrun2.png',
    'images/HowRun.png',
    'images/warm1.png',
    'images/w2.png'
    
  ];

  List<Widget> widgets = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createArrayWidget();
  }

  void createArrayWidget() {
    for (var path in images) {
      Widget widget = Image.asset(path);
      widgets.add(widget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.length == 0
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (context, index) => widgets[index],
            ),
    );
  }
}
