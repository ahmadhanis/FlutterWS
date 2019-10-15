import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Color.fromRGBO(159, 30, 99, 1),
              elevation: 2.0,
              onPressed: requestNewJob,
              tooltip: 'Request new help',
            ),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 160.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: Color.fromRGBO(159, 30, 99, 1),
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text("Available Jobs",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                            )),
                        background: Image.asset(
                          "assets/images/sliverwork.jpg",
                          fit: BoxFit.cover,
                        )),
                  ),
                ];
              },
              body: ListView.builder(
                  //Step 6: Count the data
                  itemCount: data == null ? 0 : data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 10,
                        child: InkWell(
                          onTap: () {
                            print('tapped ' + data[index]['jobid']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.network(
                                        "http://slumberjer.com/myhelper/images/${data[index]['jobid']}.jpg",
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(data[index]['jobtitle'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text("RM " + data[index]['jobprice']),
                                          Text(data[index]['jobtime'])
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
            )));
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
}
