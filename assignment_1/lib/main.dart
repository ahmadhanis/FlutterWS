import 'package:flutter/material.dart';

void main() => runApp(MyApp());
bool _isBMIVisible = true;
bool _isBMRVisible = false;
bool _isBFCVisible = false;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Column(
          children: <Widget>[
            Center(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('BMI'),
                  onPressed: _onBMI,
                ),
                RaisedButton(
                  child: Text('BMR'),
                  onPressed: _onBMR,
                ),
                RaisedButton(
                  child: Text('BFC'),
                  onPressed: _onBFC,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                BMIWidget(),
                BMRWidget(),
                BMRWidget()
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onBMI() {
    setState(() {
      _isBMIVisible = true;
      _isBMRVisible = false;
      _isBFCVisible = false;
    });
  }

  void _onBMR() {
    setState(() {
      _isBMIVisible = false;
      _isBMRVisible = true;
      _isBFCVisible = false;
    });
  }

  void _onBFC() {
    setState(() {
      _isBMIVisible = false;
      _isBMRVisible = false;
      _isBFCVisible = true;
    });
  }
}

class BMIWidget extends StatefulWidget {
  @override
  _BMIWidgetState createState() => _BMIWidgetState();
}

class _BMIWidgetState extends State<BMIWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(visible: _isBMIVisible,
        child: Column(children: <Widget>[
          Text('Hello BMI')
        ],),)
      ],
    );
  }
}

class BMRWidget extends StatefulWidget {
  @override
  _BMRWidgetState createState() => _BMRWidgetState();
}

class _BMRWidgetState extends State<BMIWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(visible: _isBMRVisible,
        child: Column(children: <Widget>[
          Text('Hello BMR')
        ],),)
      ],
    );
  }
}

class BFCWidget extends StatefulWidget {
  @override
  _BFCWidgetState createState() => _BFCWidgetState();
}

class _BFCWidgetState extends State<BMIWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(visible: _isBFCVisible,
        child: Column(children: <Widget>[
          Text('Hello BFC')
        ],),)
      ],
    );
  }
}