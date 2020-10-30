import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:praclog/newlogscreen.dart';
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
//import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainScreenSvr extends StatefulWidget {
  final User user;

  const MainScreenSvr({Key key, this.user}) : super(key: key);

  @override
  _MainScreenSvrState createState() => _MainScreenSvrState();
}

class _MainScreenSvrState extends State<MainScreenSvr> {
  //Position _currentPosition;
  List recordlist;
  String curaddress, selectedMonth, selectedYear;
  double screenHeight, screenWidth;
  String curmonth, curyear, titlecenter = "Logs for";

  final fa = new DateFormat('dd');
  final f = new DateFormat('dd/MM/yyyy');
  final fb = new DateFormat('hh:mm a');
  final fc = new DateFormat('dd/MM/yyyy hh:mm a');

  var dateUtility;
  var numdaymonth;

  List<String> monthlist = [
    "January",
    "Febuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
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
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Book',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.pageview),
              label: "Report View",
              labelBackgroundColor: Colors.white,
              onTap: loadReport),
          SpeedDialChild(
              child: Icon(MdiIcons.refreshCircle),
              label: "Refresh",
              labelBackgroundColor: Colors.white,
              onTap: () => _loadRecord(curmonth, curyear)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text("Log for: " + widget.user.name,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text("Month: " + curmonth,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Container(
                child: Text("Year: " + curyear,
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
              height: screenHeight / 14,
              margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 40,
                    child: DropdownButton(
                      //sorting dropdownoption
                      hint: Text(
                        'Month',
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
                                  color: Color.fromRGBO(101, 255, 218, 50))),
                          value: selectedMonth,
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: DropdownButton(
                      //sorting dropdownoption
                      hint: Text(
                        'Year',
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
                                  color: Color.fromRGBO(101, 255, 218, 50))),
                          value: selectedYear,
                        );
                      }).toList(),
                    ),
                  ),
                  MaterialButton(
                      color: Color.fromRGBO(101, 255, 218, 50),
                      onPressed: () => {
                            changeAtt(selectedMonth, selectedYear),
                          },
                      elevation: 5,
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
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
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.5,
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
                                      child:SingleChildScrollView(
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
                                          Text("Description:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Text(
                                              toBeginningOfSentenceCase(
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

  // Future<void> _newLogScreen() async {
  //   await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (BuildContext context) =>
  //               NewLogScreen(user: widget.user)));
  //   _loadRecord(curmonth, curyear);
  // }

  Future<void> loadReport() async {
    if (recordlist == null) {
      Toast.show("No records to print", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    const tableHeaders = [
      'Item',
      'Description',
      'Date/Time',
    ];
    final loglist = <LogRecord>[];

    for (int i = 0; i < recordlist.length; i++) {
      loglist.add(new LogRecord(
          (i + 1).toString(),
          recordlist[i]['description'],
          (fc.format(DateTime.parse(recordlist[i]['date'])).toString())));
    }
    print("TEST:" + loglist[0].description);

    //print("PDF");
    final doc = pw.Document();
    DateTime now = new DateTime.now();
    Map<int, pw.TableColumnWidth> widths = Map();
    widths = {
      0: pw.FractionColumnWidth(0.08),
      1: pw.FractionColumnWidth(0.68),
      2: pw.FractionColumnWidth(0.25),
    };
    doc.addPage(pw.MultiPage(build: (pw.Context context) {
      return <pw.Widget>[
        pw.Header(
            level: 0,
            child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text("Log Book",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 24)),
                  pw.Text("Name            :" + widget.user.name),
                  pw.Text("Matric            :" + widget.user.matric),
                  pw.Text("Organization :" + widget.user.company),
                  pw.Text("Date              :" + fc.format(now)),
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
    pr.style(message: "Loading...");
    await pr.show();
    String urlLoadJobs = "https://slumberjer.com/prak/php/load_records.php";
    http
        .post(urlLoadJobs, body: {
          "matric": widget.user.matric,
          "month": month,
          "year": year,
        })
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

  void _deleteDetail(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(
              "Delete Record " +
                  f.format(
                    DateTime.parse(recordlist[index]['date']),
                  ) +
                  "?",
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
                  http.post("https://slumberjer.com/prak/php/delete_log.php",
                      body: {
                        "rid": recordlist[index]["recid"],
                      }).then((res) {
                    print(res.body);
                    if (res.body == "success") {
                      Toast.show("Success", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                    } else {
                      Toast.show("Failed", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                    }
                    _loadRecord(curmonth, curyear);
                  }).catchError((err) {
                    print(err);
                  });
                  Navigator.of(context).pop();
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
        });
  }

  changeAtt(String selectedMonth, String selectedYear) {
    if (selectedMonth == null) {
      Toast.show("Please select month", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    if (selectedMonth == "January") {
      selectedMonth = "1";
    }
    if (selectedMonth == "Febuary") {
      selectedMonth = "2";
    }
    if (selectedMonth == "March") {
      selectedMonth = "3";
    }
    if (selectedMonth == "April") {
      selectedMonth = "4";
    }
    if (selectedMonth == "May") {
      selectedMonth = "5";
    }
    if (selectedMonth == "June") {
      selectedMonth = "6";
    }
    if (selectedMonth == "July") {
      selectedMonth = "7";
    }
    if (selectedMonth == "August") {
      selectedMonth = "8";
    }
    if (selectedMonth == "September") {
      selectedMonth = "9";
    }
    if (selectedMonth == "October") {
      selectedMonth = "10";
    }
    if (selectedMonth == "November") {
      selectedMonth = "11";
    }
    if (selectedMonth == "December") {
      selectedMonth = "12";
    }

    if (selectedYear == null) {
      Toast.show("Please select year", context,
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
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 1.5,
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
                            "https://slumberjer.com/prak/jobimages/${recordlist[index]['imagename']}.png",
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(
                          MdiIcons.imageBroken,
                          size: screenWidth / 2,
                        ),
                      )),
                  Divider(
                    color: Colors.white,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text("Description",
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
                                style: TextStyle(
                                  color: Colors.white,
                                )

                                //children: getSpan(),
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
