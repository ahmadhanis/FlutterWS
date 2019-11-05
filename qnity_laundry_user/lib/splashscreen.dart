import 'package:flutter/material.dart';
import 'package:qnity_laundry_user/mainscreen.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600]),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/qynity.png',
                scale: 2.5,
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
            //print('Sucess Login');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen()));
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
      color: Colors.teal,
      child: LinearProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.black,
        valueColor:
            new AlwaysStoppedAnimation<Color>(Color.fromRGBO(57, 195, 219, 1)),
      ),
    ));
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(57, 195, 219, .1),
  100: Color.fromRGBO(57, 195, 219, .2),
  200: Color.fromRGBO(57, 195, 219, .3),
  300: Color.fromRGBO(57, 195, 219, .4),
  400: Color.fromRGBO(57, 195, 219, .5),
  500: Color.fromRGBO(57, 195, 219, .6),
  600: Color.fromRGBO(57, 195, 219, .7),
  700: Color.fromRGBO(57, 195, 219, .8),
  800: Color.fromRGBO(57, 195, 219, .9),
  900: Color.fromRGBO(57, 195, 219, 1),
};
