import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'newlogscreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
//import 'package:geocoder/geocoder.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:date_util/date_util.dart';
import 'records.dart';
import 'user.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ParticipantScreen extends StatefulWidget {
  final User user;

  const ParticipantScreen({Key key, this.user}) : super(key: key);

  @override
  _ParticipantScreenState createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  //Position _currentPosition;
  List recordlist;
  String curaddress, selectedMonth, selectedYear;
  double screenHeight, screenWidth;
  Position _currentPosition;
  double latitude, longitude;
  String selectedLocation;
  String curmonth, curyear, titlecenter = "Log peserta";
  // TextEditingController _oldPassEditingController = new TextEditingController();
  // TextEditingController _newpassEditingController = new TextEditingController();
  final fa = new DateFormat('dd');
  final f = new DateFormat('dd/MM/yyyy');
  final fb = new DateFormat('hh:mm a');
  final fc = new DateFormat('dd/MM/yyyy hh:mm a');
  String urlUpdateLoc = "https://slumberjer.com/ayam/php/update_loc.php";
  var dateUtility;
  var numdaymonth;
  File _image;
  List<String> monthlist = [
    "Januari",
    "Februari",
    "Mac",
    "April",
    "Mei",
    "Jun",
    "Julai",
    "Ogos",
    "September",
    "Oktober",
    "November",
    "Disember"
  ];
  List<String> yearlist = [
    "2020",
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
  ];
  List days = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '24',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  ];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dateUtility = new DateUtil();

    curmonth = now.month.toString();
    curyear = now.year.toString();
    numdaymonth = dateUtility.daysInMonth(now.month, now.year);
    print(curmonth);
    print(curyear);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadRecord(curmonth, curyear));
    _getLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Buku Log',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(MdiIcons.bookAlphabet),
              label: "Log Baru",
              labelBackgroundColor: Colors.white,
              onTap: _newLogScreen),
          SpeedDialChild(
              child: Icon(Icons.pageview),
              label: "Laporan PDF",
              labelBackgroundColor: Colors.white,
              onTap: loadReport),
          SpeedDialChild(
              child: Icon(Icons.refresh),
              label: "Segarkan Logs",
              labelBackgroundColor: Colors.white,
              onTap: () => _loadRecord(curmonth, curyear)),
          SpeedDialChild(
              child: Icon(Icons.location_on_rounded),
              label: "Tetapsemula lokasi sangkar",
              labelBackgroundColor: Colors.white,
              onTap: () => updateLoc()),
          SpeedDialChild(
              child: Icon(Icons.camera_front),
              label: "Kemaskini gambar peserta",
              labelBackgroundColor: Colors.white,
              onTap: () => _onPictureSelection()),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text("Log untuk: " + widget.user.name,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text("Bulan: " + curmonth,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Container(
                child: Text("Tahun: " + curyear,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              recordlist == null
                  ? Text("")
                  : Container(
                      child: Text(
                          recordlist.length.toString() +
                              "/" +
                              numdaymonth.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
            ],
          ),
          Card(
              elevation: 5,
              child: Container(
                //color: Colors.red,
                height: screenHeight / 14,

                width: screenWidth / 0.8,
                margin: EdgeInsets.fromLTRB(5, 2, 2, 0),
                child: SingleChildScrollView(
                  //scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 40,
                        child: DropdownButton(
                          //sorting dropdownoption
                          hint: Text(
                            'Bulan',
                            style: TextStyle(
                              color: Color.fromRGBO(101, 255, 218, 50),
                            ),
                          ), // Not necessary for Option 1
                          value: selectedMonth,
                          onChanged: (newValue) {
                            setState(() {
                              selectedMonth = newValue;
                              print(selectedMonth);
                            });
                          },
                          items: monthlist.map((selectedMonth) {
                            return DropdownMenuItem(
                              child: new Text(selectedMonth,
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(101, 255, 218, 50))),
                              value: selectedMonth,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        height: 40,
                        child: DropdownButton(
                          //sorting dropdownoption
                          hint: Text(
                            'Tahun',
                            style: TextStyle(
                              color: Color.fromRGBO(101, 255, 218, 50),
                            ),
                          ), // Not necessary for Option 1
                          value: selectedYear,
                          onChanged: (newValue) {
                            setState(() {
                              selectedYear = newValue;
                              print(selectedYear);
                            });
                          },
                          items: yearlist.map((selectedYear) {
                            return DropdownMenuItem(
                              child: new Text(selectedYear,
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(101, 255, 218, 50))),
                              value: selectedYear,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 10),
                      MaterialButton(
                          color: Color.fromRGBO(101, 255, 218, 50),
                          onPressed: () => {
                                changeAtt(selectedMonth, selectedYear),
                              },
                          elevation: 5,
                          child: Text(
                            "Cari",
                            style: TextStyle(color: Colors.black),
                          )),
                      Container(
                          width: 50,
                          child: FlatButton(
                            onPressed: () => {_openGooglemap()},
                            child: Icon(
                              MdiIcons.googleMaps,
                              color: Color.fromRGBO(101, 255, 218, 50),
                            ),
                          )),
                    ],
                  ),
                ),
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
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.4,
                  children: List.generate(recordlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(2),
                        child: Card(
                          elevation: 5,
                          child: InkWell(
                            onTap: () => _onLogDetail(index),
                            onLongPress: () => _deleteDetail(index),
                            child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                                  .platform ==
                                              TargetPlatform.android
                                          ? Color.fromRGBO(101, 255, 218, 50)
                                          : Color.fromRGBO(101, 255, 218, 50),
                                      child: Text(
                                        fa.format(DateTime.parse(
                                            recordlist[index]['date'])),
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              f.format(
                                                DateTime.parse(
                                                    recordlist[index]['date']),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                          Text(
                                              fb.format(
                                                DateTime.parse(
                                                    recordlist[index]['date']),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                          Text("Penerangan:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Text(
                                              StringUtils.capitalize(
                                                  recordlist[index]
                                                      ['description']),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ],
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
    );
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .timeout(Duration(seconds: 15), onTimeout: () {
      return;
    });

    setState(() {
      latitude = _currentPosition.latitude;
      longitude = _currentPosition.longitude;
    });
  }

  Future<void> updateLoc() async {
    String icno = widget.user.icno;
    if (latitude == null || longitude == null) {
      Toast.show("Lokasi sekarang belum dijumpai", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Kemaskini Lokasi Sekarang");
    await pr.show();

    http.post(urlUpdateLoc, body: {
      "icno": icno,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Kemaskini lokasi berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        widget.user.latitude = latitude.toString();
        widget.user.latitude = longitude.toString();
      } else {
        Toast.show("Kemaskini lokasi gagal", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _openGooglemap() async {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buka lokasi penerima menggunakan aplikasi Googlemap?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
                String clatitude = widget.user.latitude;
                String clongitude = widget.user.longitude;
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

  Future<void> _newLogScreen() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Log Baru?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Text(
              "Buku log hanya boleh disimpan sekali sehari sahaja",
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
                openLogWindow(),
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

  Future<void> openLogWindow() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                NewLogScreen(user: widget.user)));
    _loadRecord(curmonth, curyear);
  }

  Future<void> loadReport() async {
    if (recordlist == null) {
      Toast.show("Tiada rekod untuk dicetak", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    const tableHeaders = [
      'Item',
      'Penerangan',
      'Hidup',
      'Mati',
      'Hilang',
      'Sakit',
      'Pemantau',
      'Tarikh'
    ];
    final loglist = <LogRecord>[];

    for (int i = 0; i < recordlist.length; i++) {
      loglist.add(new LogRecord(
        (i + 1).toString(),
        recordlist[i]['description'],
        recordlist[i]['alive'],
        recordlist[i]['dead'],
        recordlist[i]['lost'],
        recordlist[i]['sick'],
        recordlist[i]['supervisor'],
        (fc.format(DateTime.parse(recordlist[i]['date'])).toString()),
      ));
    }
    print("TEST:" + loglist[0].description);

    //print("PDF");
    final doc = pw.Document();
    DateTime now = new DateTime.now();
    Map<int, pw.TableColumnWidth> widths = Map();
    widths = {
      0: pw.FractionColumnWidth(0.05),
      1: pw.FractionColumnWidth(0.25),
      2: pw.FractionColumnWidth(0.08),
      3: pw.FractionColumnWidth(0.08),
      4: pw.FractionColumnWidth(0.08),
      5: pw.FractionColumnWidth(0.08),
      6: pw.FractionColumnWidth(0.1),
      7: pw.FractionColumnWidth(0.1)
    };
    doc.addPage(pw.MultiPage(build: (pw.Context context) {
      return <pw.Widget>[
        pw.Header(
            level: 0,
            child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text("Buku Log",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 24)),
                  pw.Text("Nama            :" + widget.user.name),
                  pw.Text("No IC            :" + widget.user.icno),
                  pw.Text("Lokasi           :" + widget.user.location),
                  pw.Text("Tarikh           :" + fc.format(now)),
                ])),
        pw.Table.fromTextArray(
          columnWidths: widths,
          border: null,
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: pw.BoxDecoration(
            borderRadius: 2,
          ),
          headerHeight: 25,
          cellHeight: 30,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerLeft,
            4: pw.Alignment.centerLeft,
            5: pw.Alignment.centerLeft,
            6: pw.Alignment.centerLeft,
            7: pw.Alignment.centerLeft,
          },
          headerStyle: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: const pw.TextStyle(
            fontSize: 10,
          ),
          rowDecoration: pw.BoxDecoration(
            border: pw.BoxBorder(
              bottom: true,
              width: .5,
            ),
          ),
          headers: List<String>.generate(
            tableHeaders.length,
            (col) => tableHeaders[col],
          ),
          data: List<List<String>>.generate(
            loglist.length,
            (row) => List<String>.generate(
              tableHeaders.length,
              (col) => loglist[row].getIndex(col),
            ),
          ),
        )
      ];
    }));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/log_report.pdf');
    file.writeAsBytesSync(doc.save());
    print(file.toString());
    OpenFile.open('${directory.path}/log_report.pdf');
  }

  Future<void> _loadRecord(String month, String year) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Memuatturun...");
    await pr.show();
    String urlLoadJobs = "https://slumberjer.com/ayam/php/load_records.php";
    http
        .post(urlLoadJobs, body: {
          "icno": widget.user.icno,
          "month": month,
          "year": year,
        })
        .timeout(const Duration(seconds: 10))
        .then((res) {
          print(res.body);

          setState(() {
            if (res.body == "nodata") {
              recordlist = null;
              Toast.show("Tiada rekod", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
              titlecenter = "Tiada rekod dijumpai";
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

  void _deleteDetail(int index) {
    TextEditingController _passEditingController = new TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(
              "Buang rekod " +
                  f.format(
                    DateTime.parse(recordlist[index]['date']),
                  ) +
                  "?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Container(
              height: screenHeight / 10,
              child: Column(
                children: [
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _passEditingController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        //labelText: 'Kata Laluan',

                        hintText: 'Kata laluan',
                        icon: Icon(MdiIcons.lock),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
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
                  http.post("https://slumberjer.com/ayam/php/delete_log.php",
                      body: {
                        "rid": recordlist[index]["recid"],
                        "pass": _passEditingController.text
                      }).then((res) {
                    print(res.body);
                    if (res.body == "success") {
                      Toast.show("Berjaya", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                          Navigator.of(context).pop();
                    } else {
                      Toast.show("Gagal", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                          Navigator.of(context).pop();
                    }
                    _loadRecord(curmonth, curyear);
                  }).catchError((err) {
                    print(err);
                  });
                  
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

  changeAtt(String selectedMonth, String selectedYear) {
    if (selectedMonth == null) {
      Toast.show("Sila pilih bulan", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    if (selectedMonth == "Januari") {
      selectedMonth = "1";
    }
    if (selectedMonth == "Febuari") {
      selectedMonth = "2";
    }
    if (selectedMonth == "Mac") {
      selectedMonth = "3";
    }
    if (selectedMonth == "April") {
      selectedMonth = "4";
    }
    if (selectedMonth == "Mei") {
      selectedMonth = "5";
    }
    if (selectedMonth == "Jun") {
      selectedMonth = "6";
    }
    if (selectedMonth == "Julai") {
      selectedMonth = "7";
    }
    if (selectedMonth == "Ogos") {
      selectedMonth = "8";
    }
    if (selectedMonth == "September") {
      selectedMonth = "9";
    }
    if (selectedMonth == "Oktober") {
      selectedMonth = "10";
    }
    if (selectedMonth == "November") {
      selectedMonth = "11";
    }
    if (selectedMonth == "Disember") {
      selectedMonth = "12";
    }

    if (selectedYear == null) {
      Toast.show("Sila pilih tahun", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    setState(() {
      curyear = selectedYear;
      curmonth = selectedMonth;
    });

    _loadRecord(selectedMonth, selectedYear);
  }

  _onLogDetail(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            // backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
                //color: Colors.white,
                height: screenHeight / 1.5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: screenHeight / 3.8,
                          width: screenWidth / 1.2,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://slumberjer.com/ayam/jobimages/${recordlist[index]['imagename']}.png",
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                                MdiIcons.imageBroken,
                                size: screenWidth / 2),
                          )),
                      Divider(
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Pemantau ",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          ),
                          Expanded(
                            child: Text(recordlist[index]['supervisor'],
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Lawatan ",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          ),
                          Expanded(
                            child: Text(
                                fc.format(
                                    DateTime.parse(recordlist[index]['date'])),
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Bil. Hidup ",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          ),
                          Expanded(
                            child: Text(recordlist[index]['alive'],
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Bil. Mati ",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          ),
                          Expanded(
                            child: Text(recordlist[index]['dead'],
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Bil. Hilang ",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          ),
                          Expanded(
                            child: Text(recordlist[index]['lost'],
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Bil. Sakit ",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          ),
                          Expanded(
                            child: Text(recordlist[index]['sick'],
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Colors.white)

                                //children: getSpan(),
                                ),
                          )
                        ],
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Text("Penerangan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))),
                      Container(
                        height: screenHeight / 3.2,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: new SingleChildScrollView(
                                child: Text(recordlist[index]['description'],
                                    softWrap: true,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(color: Colors.white)

                                    //children: getSpan(),
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )));
      },
    );
  }

  _onPictureSelection() {
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
                        "Ambil gambar dari:",
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
                        child: Text('Kamera',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Galeri',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
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

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.original,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio16x9
              ]
            : [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio5x3,
                //CropAspectRatioPreset.ratio5x4,
                //CropAspectRatioPreset.ratio7x5,
                //CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      uploadImage();
      setState(() {});
    }
  }

  Future<void> uploadImage() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Memuatnaik gambar peserta");
    await pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post("http://slumberjer.com/ayam/php/upload_image.php", body: {
      "icno": widget.user.icno,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Kemaskini gambar berjaya", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        widget.user.latitude = latitude.toString();
        widget.user.latitude = longitude.toString();
      } else {
        Toast.show("Kemaskini gambar gagal", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }
}
