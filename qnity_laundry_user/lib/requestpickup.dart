import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

Position _currentPosition;
String _name, _password, _email, _phone;
String _currentAddress = "Searching current location...";
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
final format = DateFormat("hh:mm a");
final TextEditingController _weightcontroller = TextEditingController();
final TextEditingController _jobcontroller = TextEditingController();
final TextEditingController _timecontroller = TextEditingController();
String urlUpload = "http://slumberjer.com/qnity/php/upload_job.php";

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
  void initState() {
    super.initState();
    _loadpref();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(),
          Text("REQUEST LAUNDRY PICKUP",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          SizedBox(
            height: 15,
          ),
          Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text("Pickup Location", style: TextStyle(fontSize: 18)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add_location),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                                _currentAddress ??
                                    "Waiting for your current location...",
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _weightcontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Estimated Weight(KG)',
                        icon: Icon(
                          Icons.local_laundry_service,
                          color: Color.fromRGBO(57, 195, 219, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DateTimeField(
                      controller: _timecontroller,
                      decoration: InputDecoration(
                        labelText: 'Set Pickup Time (Today)',
                        icon: Icon(
                          Icons.access_time,
                          color: Color.fromRGBO(57, 195, 219, 1),
                        ),
                      ),
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Request Pickup'),
                      color: Color.fromRGBO(57, 195, 219, 1),
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _onRequestPickup,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        // print(_getCurrentLocation);
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
      });
    } catch (e) {
      print(e);
    }
  }

  void _onRequestPickup() {
    print(_name+_email+_phone+_timecontroller.text+_weightcontroller.text+_currentAddress);
    http.post(urlUpload, body: {
      "ownername": _name,
      "owneremail": _email,
      "ownerphone": _phone,
      "pickuptime": _timecontroller.text,
      "weight": _weightcontroller.text,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "address": _currentAddress,
    }).then((res) {
      print(res.statusCode);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email') ?? '');
    _password = (prefs.getString('pass') ?? '');
    _name = (prefs.getString('name') ?? '');
    _phone = (prefs.getString('phone') ?? '');
    print(_email + "/" + _password + "/" + _name + "/" + _phone);
  }
}
