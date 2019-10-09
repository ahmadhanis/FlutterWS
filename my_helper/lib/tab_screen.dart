import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabScreen extends StatefulWidget {
  final String apptitle, email;

  TabScreen(this.apptitle, this.email);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: SwipeList(widget.email)));
  }
}

class SwipeList extends StatefulWidget {
  String email;
  SwipeList(String email) {
    this.email = email;
  }

  @override
  State<StatefulWidget> createState() {
    return ListItemWidget(email);
  }
}

class ListItemWidget extends State<SwipeList> {
  List items = getDummyList();
  String email;
  List data;
  ListItemWidget(String email) {
    this.email = email;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(email),
      ],
    );
  }

  static List getDummyList() {
    List list = List.generate(10, (i) {
      return "Item ${i + 1}";
    });
    return list;
  }

  Future<List> loadJobs(String email) async {
    String urlLoadJobs = "http://slumberjer.com/myhelper/php/load_jobs.php";
    print("Email:" + email);
    http.post(urlLoadJobs, body: {
      "email": email,
    }).then((res) {
      var extractdata = json.decode(res.body);
      data = extractdata["jobs"];
      print(data);
    }).catchError((err) {
      print(err);
    });
    return null;
  }
}
