import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qnity_laundry_user/requestpickup.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TabScreen3 extends StatefulWidget {
  final String apptitle;
  

  TabScreen3(this.apptitle);

  @override
  _TabScreen3State createState() => _TabScreen3State();
}

class _TabScreen3State extends State<TabScreen3> {
  List data;
  String _name="Not registered",_password="",_email="";

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
              // appBar: AppBar(
              //   title: const Text('Qnity Laundry'),
              //   backgroundColor: Color.fromRGBO(57, 195, 219, 1),
              // ),
              
              body: ListView.builder(
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
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
                                child: Text("Your Profile",
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
                                            Icon(Icons.location_on,
                                                color: Color.fromRGBO(
                                                    57, 195, 219, 1)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text("Universiti Utara Malaysia"),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.verified_user,
                                                color: Color.fromRGBO(
                                                    57, 195, 219, 1)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                _name??'Not registered'
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
                            ],
                          ),
                        ],
                      ),
                    );
                  })),
        ));
  }

  void requestNewPickup() {
    Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (BuildContext context) => RequestPickup()));
  }

  Future<bool> _onBackPressAppBar() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return null;
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    _name = (prefs.getString('name'));
    if (_email==null || _name == null){
      print("No pref");
      return;
    }else{
      print(_email+"/"+_name);
    }
    
    
  }
}
