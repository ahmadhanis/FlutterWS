import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_helper/mainscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

File _image;
String pathAsset = 'assets/images/sliverwork.jpg';
String urlUpload = "http://slumberjer.com/myhelper/php/upload_job.php";
final TextEditingController _jobcontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
final TextEditingController _pricecontroller = TextEditingController();
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Position _currentPosition;
String _currentAddress = "Searching current location...";

class NewJob extends StatefulWidget {
  final String email;

  const NewJob({Key key, this.email}) : super(key: key);

  @override
  _NewJobState createState() => _NewJobState();
}

class _NewJobState extends State<NewJob> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('REQUEST HELP'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: CreateNewJob(widget.email),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(email: widget.email),
        ));
    return Future.value(false);
  }
}

class CreateNewJob extends StatefulWidget {
  String email;
  CreateNewJob(String email) {
    this.email = email;
  }

  @override
  _CreateNewJobState createState() => _CreateNewJobState();
}

class _CreateNewJobState extends State<CreateNewJob> {
  String defaultValue = 'Pickup';
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image:
                    _image == null ? AssetImage(pathAsset) : FileImage(_image),
                fit: BoxFit.fill,
              )),
            )),
        Text('Click on image above to take profile picture'),
        TextField(
            controller: _jobcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Job Title',
              icon: Icon(Icons.title),
            )),
        TextField(
            controller: _pricecontroller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Job Price',
              icon: Icon(Icons.attach_money),
            )),
        TextField(
            controller: _desccontroller,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.previous,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Job Description',
              icon: Icon(Icons.info),
            )),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Icon(Icons.location_searching),
            SizedBox(
              width: 10,
            ),
            Text(_currentAddress)
          ],
        ),
        SizedBox(
          height: 10,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 300,
          height: 50,
          child: Text('Request New Job'),
          color: Color.fromRGBO(159, 30, 99, 1),
          textColor: Colors.white,
          elevation: 15,
          onPressed: _onAddJob,
        ),
      ],
    );
  }

  void _choose() async {
    _image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 400);
    setState(() {});
    //_image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onAddJob() {
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_jobcontroller.text.isEmpty) {
      Toast.show("Please enter job title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_pricecontroller.text.isEmpty) {
      Toast.show("Please enter job price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    String base64Image = base64Encode(_image.readAsBytesSync());
    print(_currentPosition.latitude.toString() +
        "/" +
        _currentPosition.longitude.toString());
    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "email": widget.email,
      "jobtitle": _jobcontroller.text,
      "jobdesc": _desccontroller.text,
      "jobprice": _pricecontroller.text,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString()
    }).then((res) {
      print(res.statusCode);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")){
         _image = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainScreen(email: widget.email)));
      }
     
    }).catchError((err) {
      print(err);
    });
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
}
