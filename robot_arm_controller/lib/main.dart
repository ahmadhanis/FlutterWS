import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());
double _gripValue = 0;
double _wristValue = 0;
double _wristrollValue = 0;
double _elbowValue = 0;
double _shoulderValue = 0;
double _waistValue = 0;
 
String urlGripper = "http://192.168.4.1/5?pos=";
String urlWrist = "http://192.168.4.1/4?pos=";
String urlwristroll = "http://192.168.4.1/3?pos=";
String urlelbow = "http://192.168.4.1/2?pos=";
String urlshoudler = "http://192.168.4.1/1?pos=";
String urlwaist = "http://192.168.4.1/0?pos=";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Robot Arm Controller'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              ),
              Text('Gripper:$_gripValue'),
              Slider(
                activeColor: Colors.indigoAccent,
                min: 0,
                max: 120,
                //divisions: 12,
                onChanged: _changeGripper,
                value: _gripValue,
              ),
              Text('Wrist:$_wristValue'),
              Slider(
                activeColor: Colors.indigoAccent,
                min: 0,
                max: 120,
                //divisions: 12,
                onChanged: _changeWrist,
                value: _wristValue,
              ),
              Text('Wrist Roll:$_wristrollValue'),
              Slider(
                activeColor: Colors.indigoAccent,
                min: 0,
                max: 120,
                //divisions: 12,
                onChanged: _changeWristRoll,
                value: _wristrollValue,
              ),
               Text('Elbow:$_elbowValue'),
              Slider(
                activeColor: Colors.indigoAccent,
                min: 0,
                max: 120,
                //divisions: 12,
                onChanged: _changeElbow,
                value: _elbowValue,
              ),
              Text('Shoulder:$_shoulderValue'),
              Slider(
                activeColor: Colors.indigoAccent,
                min: 0,
                max: 120,
                //divisions: 12,
                onChanged: _changeShoulder,
                value: _shoulderValue,
              ),
              Text('Waist:$_waistValue'),
              Slider(
                activeColor: Colors.indigoAccent,
                min: 0,
                max: 120,
                //divisions: 12,
                onChanged: _changeWaist,
                value: _waistValue,
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Future _changeGripper(double value) async{
   
    setState(() {
      _gripValue = value;
    });
      print(urlGripper+_gripValue.toString());
     http.get(urlGripper+_gripValue.floor().toString()).then((res) {
        print(res.statusCode);
        return null;
      }).catchError((err) {
        print(err);
        return null;
      }).timeout(const Duration(seconds: 5));
      return null;
  }

void _changeWrist(double value) async{
    
    setState(() {
      _wristValue = value;
    });
      print(urlWrist+_wristValue.toString());
     http.get(urlWrist+_wristValue.toString()).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
  }
  void _changeWristRoll(double value) async{
    
    setState(() {
      _wristrollValue = value;
    });
      print(urlwristroll+_wristValue.toString());
     http.get(urlwristroll+_wristValue.toString()).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
  }
  void _changeElbow(double value) async{
    
    setState(() {
      _elbowValue = value;
    });
      print(urlelbow+_elbowValue.toString());
     http.get(urlelbow+_elbowValue.toString()).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
  }
void _changeShoulder(double value) async{
    
    setState(() {
      _shoulderValue = value;
    });
      print(urlshoudler+_shoulderValue.toString());
     http.get(urlshoudler+_shoulderValue.toString()).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
  }
  void _changeWaist(double value) async{
    
    setState(() {
      _waistValue = value;
    });
      print(urlwaist+_waistValue.toString());
     http.get(urlwaist+_waistValue.toString()).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
  }
}
