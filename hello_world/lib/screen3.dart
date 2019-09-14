import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Screen 2'),
        ),
        body: Center(
          child: Container(
            child: RaisedButton(
              child: Text('Go to Screen 3'),
              onPressed: () {
                //Navigator.pop(context);
               
              }
            ),
          ),
        ));
  }
}
