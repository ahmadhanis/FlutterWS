import 'package:flutter/material.dart';
import 'screen2.dart';

class Screen1 extends StatelessWidget {
  
  final _controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Screen 1'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(controller: _controller1,),
                RaisedButton(
                  child: Text('Go to Screen 2'),
                  onPressed: (){
                    print(_controller1);
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => Screen2(value: _controller1.text)),
                      );
                    /* Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => Screen2()),
                  ); */
                },
          ),
              ],
            ),
        ),
        )
        );
  }
}