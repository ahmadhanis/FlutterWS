import 'package:flutter/material.dart';
import 'screen3.dart';

class Screen2 extends StatefulWidget {
  final String value;
  Screen2({Key key, this.value}): super(key:key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Screen 2'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('${widget.value}', style: TextStyle(fontSize:30)),
              Container(
                child: RaisedButton(
                  child: Text('Go to Screen 3'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Screen3()),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
