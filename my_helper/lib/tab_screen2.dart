import 'package:flutter/material.dart';
 
class TabScreen2 extends StatefulWidget {
  final String apptitle;
  TabScreen2(this.apptitle);

  @override
  _TabScreen2State createState() => _TabScreen2State();
}

class _TabScreen2State extends State<TabScreen2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Tab 2',style: TextStyle(fontSize: 30.0),),
      ],
    );
  }
}