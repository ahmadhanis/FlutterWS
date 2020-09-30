import 'dart:convert';
// import 'dart:io';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projek_ayam/participantscreen.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:praclog/newlogscreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
//import 'package:geocoder/geocoder.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:date_util/date_util.dart';
import 'registerscreen.dart';
import 'user.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //Position _currentPosition;
  List recordlist;
  String curaddress, selectedMonth, selectedLocation, _scanBarcode;
  double screenHeight, screenWidth;
  String titlecenter = "";
  var dateUtility;
  var numdaymonth;
  final fa = new DateFormat('dd');
  final f = new DateFormat('dd/MM/yyyy');
  final fb = new DateFormat('hh:mm a');
  final fc = new DateFormat('dd/MM/yyyy hh:mm a');
  List<String> loclist = [
    "Kerasak",
    "Changlun",
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadParticipant("aktif", "all"));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Senarai Peserta',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  child: Icon(MdiIcons.bagPersonal),
                  label: "Peserta Aktif",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _loadParticipant("aktif", "all")),
              SpeedDialChild(
                  child: Icon(MdiIcons.history),
                  label: "Peserta Lama",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _loadParticipant("selesai", "all")),
              SpeedDialChild(
                  child: Icon(MdiIcons.accountGroup),
                  label: "Daftar Peserta",
                  labelBackgroundColor: Colors.white,
                  onTap: () => _registerScreen()),
            ],
          ),
          body: Column(
            children: <Widget>[
              Container(
                  child: Text(
                "Klik utk lihat maklumat lanjut. Klik lama utk kemaskini",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )),
              Card(
                elevation: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      child: DropdownButton(
                        //sorting dropdownoption
                        hint: Text(
                          'Pilih Lokasi',
                          style: TextStyle(
                            color: Color.fromRGBO(101, 255, 218, 50),
                          ),
                        ), // Not necessary for Option 1
                        value: selectedLocation,
                        onChanged: (newValue) {
                          setState(() {
                            selectedLocation = newValue;
                            print(selectedLocation);
                          });
                        },
                        items: loclist.map((selectedLocation) {
                          return DropdownMenuItem(
                            child: new Text(selectedLocation,
                                style: TextStyle(
                                    color: Color.fromRGBO(101, 255, 218, 50))),
                            value: selectedLocation,
                          );
                        }).toList(),
                      ),
                    ),
                    MaterialButton(
                        color: Color.fromRGBO(101, 255, 218, 50),
                        onPressed: () => {
                              _loadParticipant("aktif", selectedLocation),
                            },
                        elevation: 5,
                        child: Text(
                          "Cari",
                          style: TextStyle(color: Colors.black),
                        )),
                    Container(
                        width: 50,
                        child: FlatButton(
                          onPressed: () => {scanQR()},
                          child: Icon(
                            MdiIcons.qrcodeScan,
                            color: Color.fromRGBO(101, 255, 218, 50),
                          ),
                        )),
                  ],
                ),
              ),
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
                      childAspectRatio: (screenWidth / screenHeight) / 0.22,
                      children: List.generate(recordlist.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Card(
                              elevation: 5,
                              child: InkWell(
                                onTap: () => _onLogDetail(index),
                                onLongPress: () =>
                                    _onParticipantSelection(index),
                                //onLongPress: () => _deleteDetail(index),
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: screenHeight / 6.5,
                                          width: screenHeight / 6.5,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                'https://slumberjer.com/ayam/profileimages/' +
                                                    recordlist[index]['icno'] +
                                                    ".png",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget: (context, url,
                                                    error) =>
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    )),
                                                Text(recordlist[index]['phone'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    )),
                                                Text(
                                                    recordlist[index]
                                                        ['location'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                Text(
                                                    recordlist[index]
                                                        ['address'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                Text(
                                                    f.format(DateTime.parse(
                                                        recordlist[index]
                                                            ['datejoin'])),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                // Text(
                                                //     recordlist[index]['status']
                                                //         .toString()
                                                //         .toUpperCase(),
                                                //     style: TextStyle(
                                                //         fontWeight:
                                                //             FontWeight.bold,
                                                //         color: Colors.white)),
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
                                                  message: "Whatsupp peserta",
                                                  child: FlatButton(
                                                    onPressed: () =>
                                                        {_whatsupPhone(index)},
                                                    child: Icon(
                                                      MdiIcons.whatsapp,
                                                      color: Color.fromRGBO(
                                                          101, 255, 218, 50),
                                                    ),
                                                  ),
                                                )),
                                                Flexible(
                                                  child: Tooltip(
                                                    message: "Telefon peserta",
                                                    child: FlatButton(
                                                        onPressed: () =>
                                                            {_callPhone(index)},
                                                        child: Icon(
                                                          MdiIcons.phone,
                                                          color: Color.fromRGBO(
                                                              101,
                                                              255,
                                                              218,
                                                              50),
                                                        )),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Tooltip(
                                                      message: "Buka Googlemap",
                                                      child: FlatButton(
                                                        onPressed: () => {
                                                          _openGooglemap(index)
                                                        },
                                                        child: Icon(
                                                          MdiIcons.googleMaps,
                                                          color: Color.fromRGBO(
                                                              101,
                                                              255,
                                                              218,
                                                              50),
                                                        ),
                                                      )),
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
        ));
  }

  _openGooglemap(int index) async {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buka lokasi peserta menggunakan aplikasi Googlemap?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
                String clatitude = recordlist[index]['latitude'];
                String clongitude = recordlist[index]['longitude'];
                String googleUrl =
                    'https://www.google.com/maps/search/?api=1&query=$clatitude,$clongitude';
                if (await canLaunch(googleUrl)) {
                  await launch(googleUrl);
                } else {
                  throw 'Could not open the map.';
                }
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
          'Telefon ' + recordlist[index]['name'] + '?',
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

  Future<void> _loadParticipant(String status, String loc) async {
    //String status = 'active';
    if (selectedLocation == null) {
      loc = "all";
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Loading...");
    await pr.show();
    String urlLoadJobs = "https://slumberjer.com/ayam/php/load_participant.php";
    http
        .post(urlLoadJobs, body: {"status": status, "location": loc})
        .timeout(const Duration(seconds: 15))
        .then((res) {
          print(res.body);
          setState(() {
            if (res.body == "nodata") {
              recordlist = null;
              Toast.show("Tiada rekod", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
              titlecenter = "TIada rekod dijumpai";
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
        icno: recordlist[index]['icno'],
        phone: recordlist[index]['phone'],
        address: recordlist[index]['homeadd'],
        location: recordlist[index]['location']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ParticipantScreen(
                  user: _user,
                )));
  }

  _onLogDetailQR() {
    if (_scanBarcode == null) {
      Toast.show("Sila scan QR:", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    for (int i = 0; i < recordlist.length; i++) {
      if (recordlist[i]['icno'] == _scanBarcode) {
        User _user = new User(
            name: recordlist[i]['name'],
            icno: recordlist[i]['icno'],
            phone: recordlist[i]['phone'],
            address: recordlist[i]['homeadd'],
            location: recordlist[i]['location']);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ParticipantScreen(
                      user: _user,
                    )));
      }
    }
  }
  // _changePasswordDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //           //backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //           content: new Container(
  //               //color: Colors.white,
  //               height: screenHeight / 2.8,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Container(
  //                         alignment: Alignment.center,
  //                         child: Text("Change your password",
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 16,
  //                                 color: Colors.white))),
  //                     TextField(
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                       controller: _oldPassEditingController,
  //                       decoration: InputDecoration(
  //                         labelText: 'Old Password',
  //                         icon: Icon(Icons.lock),
  //                       ),
  //                       obscureText: true,
  //                     ),
  //                     TextField(
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                       controller: _newpassEditingController,
  //                       decoration: InputDecoration(
  //                         labelText: 'New Password',
  //                         icon: Icon(Icons.lock),
  //                       ),
  //                       obscureText: true,
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     MaterialButton(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(5.0)),
  //                       minWidth: 200,
  //                       height: 50,
  //                       child: Text('Change',
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                           )),
  //                       color: Color.fromRGBO(101, 255, 218, 50),
  //                       textColor: Colors.white,
  //                       elevation: 10,
  //                       onPressed: () => _changePasswordDialogConfirm(
  //                           _oldPassEditingController.text,
  //                           _newpassEditingController.text),
  //                     ),
  //                   ],
  //                 ),
  //               )));
  //     },
  //   );
  // }

  // void _changePasswordDialogConfirm(String oldp, String newp) {
  //   if (oldp == "" && newp == "") {
  //     Toast.show("Please enter old and new password", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
  //     return;
  //   }
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //         title: new Text(
  //           "Change your password?",
  //           style: TextStyle(
  //             color: Colors.white,
  //           ),
  //         ),
  //         content:
  //             new Text("Are you sure?", style: TextStyle(color: Colors.white)),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new FlatButton(
  //             child: new Text(
  //               "Ya",
  //               style: TextStyle(
  //                 color: Color.fromRGBO(101, 255, 218, 50),
  //               ),
  //             ),
  //             onPressed: () => {
  //               Navigator.of(context).pop(),
  //               //finalChangePassword(oldp, newp)
  //             },
  //           ),
  //           new FlatButton(
  //             child: new Text(
  //               "No",
  //               style: TextStyle(
  //                 color: Color.fromRGBO(101, 255, 218, 50),
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _registerScreen() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
    _loadParticipant("aktif", "all");
  }

  // Future<void> finalChangePassword(String oldp, String newp) async {
  //   ProgressDialog pr = new ProgressDialog(context,
  //       type: ProgressDialogType.Normal, isDismissible: true);
  //   pr.style(message: "Updating password...");
  //   await pr.show();
  //   String urlreset = "https://slumberjer.com/prak/php/reset.php";
  //   http
  //       .post(urlreset, body: {
  //         "email": widget.user.email,
  //         "oldpass": oldp,
  //         "newpass": newp,
  //         "user": "SUPERVISOR"
  //       })
  //       .timeout(const Duration(seconds: 10))
  //       .then((res) {
  //         print("Respond:" + res.body);
  //         setState(() {
  //           if (res.body == "success") {
  //             Toast.show("Success", context,
  //                 duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
  //             Navigator.of(context).pop();
  //           } else {
  //             Toast.show("Failed", context,
  //                 duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
  //           }
  //         });
  //       })
  //       .catchError((err) {
  //         print(err);
  //         Toast.show("Error:" + err.toString(), context,
  //             duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
  //       });
  //   await pr.hide();
  // }

  _onParticipantSelection(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Pilihan:",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Buang peserta',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _deleteParticipant(index)},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Kemaskini status selesai',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _updateStatus(index),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _deleteParticipant(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(
              "Buang rekod peserta " + recordlist[index]['name'] + "?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "Yes",
                  style: TextStyle(
                    color: Color.fromRGBO(101, 255, 218, 50),
                  ),
                ),
                onPressed: () async {
                  http.post(
                      "https://slumberjer.com/ayam/php/delete_participant.php",
                      body: {
                        "icno": recordlist[index]["icno"],
                      }).then((res) {
                    print(res.body);
                    if (res.body == "success") {
                      Toast.show("Berjaya", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                    } else {
                      Toast.show("Gagal", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                    }
                    _loadParticipant("aktif", "all");
                  }).catchError((err) {
                    print(err);
                  });
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  "Tidak",
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
        });
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
            "Kemaskini status selesai untuk " + recordlist[index]['name'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text("Tindakan ini tidak boleh diubah. Anda pasti?",
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
                finalChangeStatus(index),
                _loadParticipant("aktif", "all")
              },
            ),
            new FlatButton(
              child: new Text(
                "Tidak",
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
    String icno = recordlist[index]['icno'];
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Loading...");
    await pr.show();
    String urlLoadJobs = "https://slumberjer.com/ayam/php/update_status.php";
    http
        .post(urlLoadJobs, body: {"icno": icno, "status": "selesai"})
        .timeout(const Duration(seconds: 10))
        .then((res) {
          print(res.body);
          setState(() {
            if (res.body == "success") {
              Toast.show("Kemaskini berjaya", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            } else {
              Toast.show("Kemaskini tidak berjaya", context,
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

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      Toast.show("Imbasan QR batal", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    _onLogDetailQR();
  }
}
