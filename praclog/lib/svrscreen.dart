import 'dart:convert';
// import 'dart:io';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:praclog/newlogscreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
//import 'package:geocoder/geocoder.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:date_util/date_util.dart';
import 'mainscreensvr.dart';
import 'user.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SvrScreen extends StatefulWidget {
  final User user;

  const SvrScreen({Key key, this.user}) : super(key: key);

  @override
  _SvrScreenState createState() => _SvrScreenState();
}

class _SvrScreenState extends State<SvrScreen> {
  //Position _currentPosition;
  List recordlist;
  String curaddress, selectedMonth, selectedYear;
  double screenHeight, screenWidth;
  String titlecenter = "";
  TextEditingController _oldPassEditingController = new TextEditingController();
  TextEditingController _newpassEditingController = new TextEditingController();
  var dateUtility;
  var numdaymonth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadStudents("active"));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Students',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(MdiIcons.bagPersonal),
              label: "Active Students",
              labelBackgroundColor: Colors.white,
              onTap: () => _loadStudents("active")),
          SpeedDialChild(
              child: Icon(MdiIcons.history),
              label: "Previous Students",
              labelBackgroundColor: Colors.white,
              onTap: () => _loadStudents("completed")),
          SpeedDialChild(
              child: Icon(MdiIcons.keyChange),
              label: "Change your password",
              labelBackgroundColor: Colors.white,
              onTap: () => _changePasswordDialog()),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              child: Text(
            "Click to see details. Long click to update status",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          )),
          recordlist == null
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
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.2,
                  children: List.generate(recordlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                          elevation: 5,
                          child: InkWell(
                            onTap: () => _onLogDetail(index),
                            onLongPress: () => _updateStatus(index),
                            //onLongPress: () => _deleteDetail(index),
                            child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      height: screenHeight / 6,
                                      width: screenHeight / 6,
                                      child: ClipOval(
                                          child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            'https://slumberjer.com/prak/profileimages/' +
                                                recordlist[index]['matric'] +
                                                ".png",
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(MdiIcons.imageBroken),
                                      )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                          child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(recordlist[index]['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                )),
                                            Text(recordlist[index]['email'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )),
                                            Text(recordlist[index]['phone'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            Text(recordlist[index]['company'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            Text(
                                                recordlist[index]['status']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      )),
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Column(
                                          children: [
                                            Flexible(
                                                child: Tooltip(
                                              message: "Whatsupp student",
                                              child: FlatButton(
                                                onPressed: () =>
                                                    {_whatsupPhone(index)},
                                                child: Icon(
                                                  MdiIcons.whatsapp,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            )),
                                            Flexible(
                                              child: Tooltip(
                                                message: "Call student",
                                                child: FlatButton(
                                                    onPressed: () =>
                                                        {_callPhone(index)},
                                                    child: Icon(
                                                      MdiIcons.phone,
                                                      color: Colors.blueGrey,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                )),
                          ),
                        ));
                  }),
                ))
        ],
      ),
    );
  }

  _whatsupPhone(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Whatsup ' + recordlist[index]['name'] + '?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                FlutterOpenWhatsapp.sendSingleMessage(
                    "+60" + recordlist[index]['phone'], "");
              },
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  void _callPhone(int index) async {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Call ' + recordlist[index]['name'] + '?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePhoneCall('tel:' + recordlist[index]['phone']);
              },
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _loadStudents(String status) async {
    //String status = 'active';
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Loading...");
    await pr.show();
    String urlLoadJobs = "https://slumberjer.com/prak/php/load_students.php";
    http
        .post(urlLoadJobs, body: {"id": widget.user.matric, "status": status})
        .timeout(const Duration(seconds: 10))
        .then((res) {
          print(res.body);
          setState(() {
            if (res.body == "nodata") {
              recordlist = null;
              Toast.show("No records", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
              titlecenter = "No records found";
            } else {
              var extractdata = json.decode(res.body);
              recordlist = extractdata["records"];
            }
          });
        })
        .catchError((err) {
          print(err);
          Toast.show("Error:" + err.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        });
    await pr.hide();
  }

  _onLogDetail(int index) {
    print(recordlist[index]['name']);
    User _user = new User(
        name: recordlist[index]['name'],
        email: recordlist[index]['email'],
        password: "",
        phone: recordlist[index]['phone'],
        company: recordlist[index]['company'],
        supervisor: widget.user.matric,
        matric: recordlist[index]['matric']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainScreenSvr(
                  user: _user,
                )));
  }

  _changePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
                //color: Colors.white,
                height: screenHeight / 2.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: Text("Change your password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white))),
                      TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: _oldPassEditingController,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          icon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: _newpassEditingController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          icon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 200,
                        height: 50,
                        child: Text('Change',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () => _changePasswordDialogConfirm(
                            _oldPassEditingController.text,
                            _newpassEditingController.text),
                      ),
                    ],
                  ),
                )));
      },
    );
  }

  void _changePasswordDialogConfirm(String oldp, String newp) {
    if (oldp == "" && newp == "") {
      Toast.show("Please enter old and new password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Change your password?",
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
                finalChangePassword(oldp, newp)
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

  Future<void> finalChangePassword(String oldp, String newp) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Updating password...");
    await pr.show();
    String urlreset = "https://slumberjer.com/prak/php/reset.php";
    http
        .post(urlreset, body: {
          "email": widget.user.email,
          "oldpass": oldp,
          "newpass": newp,
          "user": "SUPERVISOR"
        })
        .timeout(const Duration(seconds: 10))
        .then((res) {
          print("Respond:" + res.body);
          setState(() {
            if (res.body == "success") {
              Toast.show("Success", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
              Navigator.of(context).pop();
            } else {
              Toast.show("Failed", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            }
          });
        })
        .catchError((err) {
          print(err);
          Toast.show("Error:" + err.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        });
    await pr.hide();
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
            "Update status to completed for " + recordlist[index]['name'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text("This action is irreversible. Are you sure?",
              style: TextStyle(color: Colors.white)),
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
                finalChangeStatus(index),
                _loadStudents("active")
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

  finalChangeStatus(int index) async {
    String em = recordlist[index]['email'];
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Loading...");
    await pr.show();
    String urlLoadJobs = "https://slumberjer.com/prak/php/update_status.php";
    http
        .post(urlLoadJobs, body: {"email": em, "status": "completed"})
        .timeout(const Duration(seconds: 10))
        .then((res) {
          print(res.body);
          setState(() {
            if (res.body == "success") {
              Toast.show("Update Success", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            } else {
              Toast.show("Update Status Failed", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            }
          });
        })
        .catchError((err) {
          print(err);
          Toast.show("Error:" + err.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        });
    await pr.hide();
  }
}
