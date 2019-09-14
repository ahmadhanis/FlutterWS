import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _emcontroller = TextEditingController();
  String _email2 = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Text('Email'),
              alignment: Alignment.centerLeft,
            ),
            TextField(controller: _emcontroller),
            RaisedButton(
              child: Text("Press Me"),
              onPressed: _onPressed,
            ),
            Text("Submitted Text: $_email2"),
          ],
        ),
      ),
    );
  }

  _onPressed() {
    setState(() {
      _email2 = _emcontroller.text;
    });
  }
}
