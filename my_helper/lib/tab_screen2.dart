import 'package:flutter/material.dart';
 
class TabScreen2 extends StatelessWidget {
  final Color color;
  final String apptitle;
  TabScreen2(this.color,this.apptitle);
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Tab 2'),
        MaterialButton(child: Text('OK'),onPressed: null,),
        Text('Welcome')
      ],
    );
  }
}