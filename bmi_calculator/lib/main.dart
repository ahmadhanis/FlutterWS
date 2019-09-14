import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _acontroller = TextEditingController();
  final TextEditingController _bcontroller = TextEditingController();
  double a = 0.0, b = 0.0, result = 0.0;
  String bmi;
  String img = "assets/images/default.jpg";
  AudioCache audioCache = new AudioCache();
  AudioPlayer audioPlayer = new AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('BMI Application'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(img, height: 200.0, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Height(cm)",
                ),
                keyboardType: TextInputType.numberWithOptions(),
                controller: _acontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Weight(kg)",
                ),
                keyboardType: TextInputType.numberWithOptions(),
                controller: _bcontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: RaisedButton(
                child: Text("Calculate BMI"),
                onPressed: _onPress,
              ),
            ),
            Text("BMI: $bmi"),
          ],
        ),
      ),
    );
  }

  void _onPress() {
    setState(() {
      a = double.parse(_acontroller.text);
      b = double.parse(_bcontroller.text);
      result = (b * b) / a;
      bmi = format(result);
      if (result > 25) {
        img = "assets/images/overweight.jpg";
        loadFail();
      } else if ((result <= 24.9) && (result >= 18.5)) {
        img = "assets/images/normal.jpg";
        loadOk();
      } else if (result < 18.5) {
        img = "assets/images/underweight.jpg";
        loadFail();
      }
    });
  }

  Future loadOk() async {
    audioPlayer = await AudioCache().play("audio/ok.wav");
  }

  Future loadFail() async {
    audioPlayer = await AudioCache().play("audio/fail.wav");
  }

  @override
  void dispose() {
    audioPlayer = null;
    super.dispose();
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}
