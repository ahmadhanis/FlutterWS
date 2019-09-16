import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: Column(
          children: <Widget>[
            Text('Hello World',style: TextStyle(fontSize: 18),),
            Text('Second Hello World'),
          ],
        ),
      ),
    );
  }
}