import 'package:flutter/material.dart';
import 'package:food_ninja/loginpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/foodninjared.png',
                width: 230,
                height: 230,
              ),
              SizedBox(
                height: 20,
              ),
              new ProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      width: 200,
      color: Colors.redAccent,
      child: LinearProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.black,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
      ),
    ));
  }
}

Map<int, Color> color =
{
50:Color.fromRGBO(255,0,0, .1),
100:Color.fromRGBO(255,0,0, .2),
200:Color.fromRGBO(255,0,0, .3),
300:Color.fromRGBO(255,0,0, .4),
400:Color.fromRGBO(255,0,0, .5),
500:Color.fromRGBO(255,0,0, .6),
600:Color.fromRGBO(255,0,0, .7),
700:Color.fromRGBO(255,0,0, .8),
800:Color.fromRGBO(255,0,0, .9),
900:Color.fromRGBO(255,0,0, 1),
};