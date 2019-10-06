import 'package:flutter/material.dart';
 
class TabScreen extends StatelessWidget {
  final Color color;
  final String apptitle;
  TabScreen(this.color,this.apptitle);
 
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: color,
    );
  }
}