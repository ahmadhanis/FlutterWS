import 'package:flutter/material.dart';

import 'mainscreen.dart';

class RequestPickup extends StatefulWidget {
  @override
  _RequestPickupState createState() => _RequestPickupState();
}

class _RequestPickupState extends State<RequestPickup> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('REQUEST PICKUP'),
            backgroundColor: Color.fromRGBO(57, 195, 219, 1),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: RequestPickupBody(),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() {
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
    return Future.value(false);
  }
}

class RequestPickupBody extends StatefulWidget {
  RequestPickupBody({Key key}) : super(key: key);

  @override
  _RequestPickupBodyState createState() => _RequestPickupBodyState();
}

class _RequestPickupBodyState extends State<RequestPickupBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}
