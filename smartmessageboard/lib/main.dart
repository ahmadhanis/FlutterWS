import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());
final TextEditingController _idcontroller = TextEditingController();
final TextEditingController _msjcontroller = TextEditingController();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final firebaseref = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Smart Message Board'),
        ),
        body: Center(
          child: Container(
              child: Column(
            children: <Widget>[
              TextField(
                  controller: _idcontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Board ID', icon: Icon(Icons.account_circle))),
              TextField(
                  controller: _msjcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Message', icon: Icon(Icons.message))),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: 100,
                    height: 50,
                    child: Text('SEND MESSAGE'),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    elevation: 15,
                    onPressed: sendMessage,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: 100,
                    height: 50,
                    child: Text('LOAD MESSAGE'),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    elevation: 15,
                    onPressed: loadMessage,
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }

  void sendMessage() {
    if (_idcontroller.text.isEmpty || _msjcontroller.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter required input!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      updateData();
    }
  }

  void loadMessage() {
    if (_idcontroller.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter required input!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      getData();
    }
  }

  void getData() {
    String devid = _idcontroller.text;
    firebaseref.child(devid).once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      if (snapshot.value == null) {
        print("Hello");
        _msjcontroller.text = "";
        Fluttertoast.showToast(
            msg: "No Data!!!",
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      } else {
        String msj = '${snapshot.value['message']}';
        _msjcontroller.text = msj;
        Fluttertoast.showToast(
          msg: "Success",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    });
  }

  void updateData() {
    String devid = _idcontroller.text;
    String usermsj = _msjcontroller.text;

    firebaseref.child(devid).once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        firebaseref.child(devid).update({'message': usermsj});
        Fluttertoast.showToast(
          msg: "Success",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Not found",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    });
  }
}
