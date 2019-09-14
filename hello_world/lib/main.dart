import 'package:flutter/material.dart';
import 'package:hello_world/screen1.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Screen1(),
    /*   routes: <String, WidgetBuilder>{
        'Screen1': (BuildContext context) => Screen1(),
        'Screen2': (BuildContext context) => Screen2(),
        'Screen3': (BuildContext context) => Screen3(),
      }, */
    );
  }
}

