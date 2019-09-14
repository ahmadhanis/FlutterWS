import 'package:flutter/material.dart';

var _key = new GlobalKey<ScaffoldState>();

class MainLayout extends StatelessWidget {
  final String status;
  MainLayout({Key key, @required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ninja',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Food Ninja'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text(status),

              //Image.asset('name')
            ],
          ),
        ),
      ),
    );
  }
}

void showInSnackBar(String value) async {
  _key.currentState.showSnackBar(new SnackBar(content: new Text(value)));
}
