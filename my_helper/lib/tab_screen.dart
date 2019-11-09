import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_helper/jobdetail.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_helper/newjob.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

double perpage=1;

class TabScreen extends StatefulWidget {
  final String apptitle;
  final String email;
  final String radius;


  TabScreen(this.apptitle, this.email, this.radius);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color.fromRGBO(159, 30, 99, 1)));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Color.fromRGBO(159, 30, 99, 1),
              elevation: 2.0,
              onPressed: requestNewJob,
              tooltip: 'Request new help',
            ),
            body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(159, 30, 99, 1),
              onRefresh: () async {
                await refreshList();
              },
              child: ListView.builder(
                  //Step 6: Count the data
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/background.png",
                                fit: BoxFit.fitWidth,
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text("MyHelper",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 300,
                                    height: 120,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.verified_user,
                                                    color: Color.fromRGBO(
                                                        159, 30, 99, 1)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.email,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.location_on,
                                                    color: Color.fromRGBO(
                                                        159, 30, 99, 1)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(_currentAddress),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.rounded_corner,
                                                    color: Color.fromRGBO(
                                                        159, 30, 99, 1)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      "Job Radius within " +
                                                          widget.radius +
                                                          " KM"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              color: Color.fromRGBO(159, 30, 99, 1),
                              child: Center(
                                child: Text("Jobs Available Today",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == data.length && perpage>1) {
                      return Container(
                        width: 250,
                        color: Colors.white,
                        child: MaterialButton(
                          child: Text("Load More",style: TextStyle(color: Colors.black),),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _onJobDetail(
                              data[index]['jobid'],
                              data[index]['jobprice'],
                              data[index]['jobdesc'],
                              data[index]['jobowner'],
                              data[index]['jobimage'],
                              data[index]['jobtime'],
                              data[index]['jobtitle'],
                              data[index]['joblatitude'],
                              data[index]['joblongitude']),
                          onLongPress: _onJobDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(
                                    "http://slumberjer.com/myhelper/images/${data[index]['jobimage']}.jpg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['jobtitle']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        RatingBar(
                                          itemCount: 5,
                                          itemSize: 12,
                                          initialRating: 4.5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("RM " + data[index]['jobprice']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['jobtime']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_getCurrentLocation);
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        init();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> makeRequest() async {
    String urlLoadJobs = "http://slumberjer.com/myhelper/php/load_jobs.php";

    http.post(urlLoadJobs, body: {
      "email": widget.email,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "radius": widget.radius,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["jobs"];
        perpage = (data.length / 10);
        print("Perpage");
        print(perpage);
      });
    }).catchError((err) {
      print(err);
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void requestNewJob() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                NewJob(email: widget.email, radius: widget.radius)));
  }

//data[index]['jobid'],data[index]['jobprice'],data[index]['jobdesc'],data[index]['jobowner'],data[index]['jobimage'],data[index]['jobtime']
  void _onJobDetail(
      String jobid,
      String jobprice,
      String jobdesc,
      String jobowner,
      String jobimage,
      String jobtime,
      String jobtitle,
      String joblatitude,
      String joblongitude) {
    //print(data);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => JobDetail(
                useremail: widget.email,
                jobid: jobid,
                jobprice: jobprice,
                jobdesc: jobdesc,
                jobowner: jobowner,
                jobimage: jobimage,
                jobtitle: jobtitle,
                jobtime: jobtime,
                joblatitude: joblatitude,
                joblongitude: joblongitude,
                jobradius: widget.radius)));
  }

  void _onJobDelete() {
    print("Delete");
  }
}
