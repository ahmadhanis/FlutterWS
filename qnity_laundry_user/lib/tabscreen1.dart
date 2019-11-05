import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qnity_laundry_user/registrationscreen.dart';
import 'package:qnity_laundry_user/requestpickup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TabScreen1 extends StatefulWidget {
  final String apptitle;

  TabScreen1(this.apptitle);

  @override
  _TabScreen1State createState() => _TabScreen1State();
}

class _TabScreen1State extends State<TabScreen1> {
  List data;
  String _name, _password, _email, _phone;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              resizeToAvoidBottomPadding: false,
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Color.fromRGBO(57, 195, 219, 1),
                elevation: 2.0,
                onPressed: requestNewPickup,
                tooltip: 'Request Pickup',
              ),
              body: ListView.builder(
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
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
                                      child: Text("QNity-Laundry",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                    Center(
                                      child: Text("Request Pickup",
                                          style: TextStyle(
                                              fontSize: 18,
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
                                                          57, 195, 219, 1)),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Flexible(
                                                    child: Text(_name ??
                                                        'Please register'),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(Icons.phone,
                                                      color: Color.fromRGBO(
                                                          57, 195, 219, 1)),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Flexible(
                                                    child: Text(_phone ??
                                                        'Please register'),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(Icons.alternate_email,
                                                      color: Color.fromRGBO(
                                                          57, 195, 219, 1)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(_email ??
                                                        'Please register'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text("Your Current Laudry Request",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 5,
                        child: InkWell(
                          onTap: _onJobDetails,
                          child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Container(
                                        //alignment: Alignment.center,
                                        child: Text(data[index]['id'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 1,
                                      ),
                                      Container(
                                        child: new Column(
                                          //crossAxisAlignment:
                                           //   CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(data[index]['weight'] +
                                                ' KG Laundry request'),
                                            Text('Pickup time at ' +
                                                data[index]['pickuptime']),
                                            Text('at ' + data[index]['address'],
                                                maxLines: 3),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      Column(
                                        children: <Widget>[
                                          Text('Status'),
                                          Text(data[index]['status']),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    );
                  })),
        ));
  }

  void requestNewPickup() {
    print(_email);
    if (_email.length < 1) {
      Toast.show("Please register to use this application.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RegisterScreen()));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RequestPickup()));
    }
  }

  Future<bool> _onBackPressAppBar() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return null;
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email') ?? '');
    _password = (prefs.getString('pass') ?? '');
    _name = (prefs.getString('name') ?? '');
    _phone = (prefs.getString('phone') ?? '');

    print(_email + _password);
    setState(() {
      _email = (prefs.getString('email') ?? '');
      _password = (prefs.getString('pass') ?? '');
      _name = (prefs.getString('name') ?? 'Please register');
      if (_name.length < 1) {
        _name = "Please register";
      }
    });
    if (_email == null || _password == null) {
      print("No pref");
      return;
    } else {
      print(_email + "/" + _password);
    }
    init();
  }

  Future<String> makeRequest() async {
    print('Inside makerequest');
    print(_email);
    String urlLoadJobs = "http://slumberjer.com/qnity/php/load_jobs.php";

    http.post(urlLoadJobs, body: {
      "owneremail": _email,
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
    //_getCurrentLocation();
  }

  void _onJobDetails() {}
}
