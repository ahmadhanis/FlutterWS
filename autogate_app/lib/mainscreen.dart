import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'autogate.dart';
import 'user.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final firebaseref = FirebaseDatabase.instance.reference();
  List<AutoGate> listGate = new List();
  double screenHeight, screenWidth;
  String titlecenter = "Loading";
  TextEditingController _gateidEditingController = new TextEditingController();
  TextEditingController _descEditingController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Your Autogate',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(MdiIcons.gate),
                  label: "New Autogate",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _onNewGateDialog()),
            ],
          ),
          body: Column(
            children: <Widget>[
              Container(
                  child: Text(
                "Click to show details",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )),
              listGate == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))))
                  : Flexible(
                      child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.4,
                      children: List.generate(listGate.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Card(
                              elevation: 5,
                              child: InkWell(
                                onLongPress: () => _updateStatus(index),
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                        listGate[index]
                                                            .desc
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Flexible(
                                            child: Tooltip(
                                          message: "Press",
                                          child: FlatButton(
                                            onPressed: () =>
                                                {updateData(index)},
                                            child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Icon(
                                                  MdiIcons.power,
                                                  color: Color.fromRGBO(
                                                      101, 255, 218, 50),
                                                )),
                                          ),
                                        )),
                                      ],
                                    )),
                              ),
                            ));
                      }),
                    ))
            ],
          ),
        ));
  }

  Future<void> getData() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Log in...");
    await pr.show();

    firebaseref
        .child("users")
        .child(encodeUserEmail(widget.user.email))
        .child("autogate")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> map = snapshot.value;
        setState(() {
          listGate.clear();
        });
        for (int i = 0; i < map.length; i++) {
          String gateid = map.keys.elementAt(i);
          String desc = map.values.toList()[i]["desc"];
          AutoGate newgate = AutoGate(gateid, desc);
          setState(() {
            listGate.add(newgate);
          });
        }
        print(listGate);
      } else {
        titlecenter = "No Autogate available";
      }
    });
    await pr.hide();
  }

  static String encodeUserEmail(String userEmail) {
    return userEmail.replaceAll(".", ",");
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Keluar aplikasi ini?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Anda Pasti?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Keluar",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Batal",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  _updateStatus(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete gate " + listGate[index].desc,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
                _deleteGate(index),
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateData(int index) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Sending command");
    await pr.show();
    firebaseref.child("devices").once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        firebaseref
            .child("devices")
            .child(listGate[index].gateid)
            .update({'status': generateRandomString(6)});
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    });
    await pr.hide();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  _deleteGate(int index) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting gate...");
    await pr.show();
    firebaseref
        .reference()
        .child("users")
        .child(widget.user.email)
        .child("autogate")
        .child(listGate[index].gateid)
        .remove()
        .then((_) {
      getData();
    });
    await pr.hide();
  }

  _onNewGateDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              // backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: new Container(
                  height: screenHeight / 1.75,
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Text("Create New AutoGate",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: screenHeight / 3.8,
                          width: screenWidth / 1.2,
                          child: Image(
                            image: AssetImage('assets/images/login.png'),
                          )),
                      SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Gate ID ",
                              style: TextStyle(color: Colors.white),

                              //children: getSpan(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                                controller: _gateidEditingController,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("Description ",
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                                controller: _descEditingController,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                          width: screenWidth / 1.5,
                          height: screenHeight / 12,
                          child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              color: Color.fromRGBO(101, 255, 218, 50),
                              onPressed: () => {
                                    Navigator.of(context).pop(),
                                    _onNewGate(),
                                  },
                              elevation: 5,
                              child: Text(
                                "Save",
                                style: TextStyle(color: Colors.black),
                              ))),
                    ]),
                  )));
        });
  }

  _onNewGate() async {
    if (_gateidEditingController.text == "" &&
        _descEditingController.text == "") {
      Toast.show("Please fill in gate details first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "New gate...");
    await pr.show();
    await firebaseref.child("users").once().then((DataSnapshot snapshot) {
      firebaseref
          .child("users")
          .child(widget.user.email)
          .child("autogate")
          .child(_gateidEditingController.text)
          .set({
        'desc': _descEditingController.text,
      });
    });
    await getData();
    await pr.hide();
  }
}
