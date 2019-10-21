import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_helper/jobdetail.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:my_helper/newjob.dart';

class TabScreen extends StatefulWidget {
  final String apptitle;
  final String email;

  TabScreen(this.apptitle, this.email);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List data;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
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
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: data == null ? 1 : data.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Image.asset("assets/images/background.png"),
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
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on,
                                                color: Color.fromRGBO(
                                                    159, 30, 99, 1)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                "School of Computing, Universiti Utara Malaysia, Sintok, Kedah",
                                              ),
                                            ),
                                          ],
                                        ),
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                        Container(
                          width: 300,
                          child: TextField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                labelText: 'Search',
                                icon: Icon(Icons.search),
                              )),
                        ),
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
                index -= 1;
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: _onJobDetail,
                      onLongPress: _onJobDelete,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  height: 130,
                                  width: 350,
                                  child: Image.network(
                                    "http://slumberjer.com/myhelper/images/${data[index]['jobimage']}.jpg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Row(
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
                                        ],
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
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  Future<String> makeRequest() async {
    String urlLoadJobs = "http://slumberjer.com/myhelper/php/load_jobs.php";

    http.post(urlLoadJobs, body: {
      //"email": widget.email,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["jobs"];
        print(data);
      });
    }).catchError((err) {
      print(err);
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
  }

  void requestNewJob() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NewJob(email: widget.email)));
  }

  void _onJobDetail() {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
  }

  void _onJobDelete() {
    print("Delete");
  }
}
