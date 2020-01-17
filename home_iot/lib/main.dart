import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _textEditingController,
              ),
              MaterialButton(
                onPressed: _onPress,
                child: Text("Insert"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onPress() {
    
  }
}
