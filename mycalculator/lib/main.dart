import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _acontroller = TextEditingController();
  final TextEditingController _bcontroller = TextEditingController();
  double a = 0.0, b = 0.0, result = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Basic Calculator App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "First Number",
                ),
                keyboardType: TextInputType.numberWithOptions(),
                controller: _acontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Second Number",
                ),
                keyboardType: TextInputType.numberWithOptions(),
                controller: _bcontroller,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
                    child: Text("+"),
                    onPressed: _onPress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
                    child: Text("-"),
                    onPressed: _onPress,
                  ),
                ),
              ],
            ),
            Text("Result: $result"),
          ],
        ),
      ),
    );
  }

  void _onPress() {
    setState(() {
      a = double.parse(_acontroller.text);
      b = double.parse(_bcontroller.text);
      result = a + b;
    });
  }
}
