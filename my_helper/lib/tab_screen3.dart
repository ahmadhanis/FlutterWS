import 'package:flutter/material.dart';
 
class TabScreen3 extends StatefulWidget {
  final String apptitle;
  TabScreen3(this.apptitle);

  @override
  _TabScreen3State createState() => _TabScreen3State();
}

class _TabScreen3State extends State<TabScreen3> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Tab 3',style: TextStyle(fontSize: 30.0),),
      ],
    );
  }
}