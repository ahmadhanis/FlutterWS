import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'loginpage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

String pathAsset = 'assets/images/profile.png';
File _image;
String urlUpload = "http://slumberjer.com/foodninja/php/register_user.php";

final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
String _email, _password, _phone,_name;

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterUser({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('New User Registration'),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
            )),
        Text('Click on the image above to take profile picture'),
        TextField(
            controller: _namecontroller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Name',
              icon: Icon(Icons.person),
            )),

        TextField(
            controller: _emcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        TextField(
          controller: _passcontroller,
          decoration:
              InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
          obscureText: true,
        ),
        TextField(
            controller: _phcontroller,
            keyboardType: TextInputType.phone,
            decoration:
                InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone))),
        SizedBox(
          height: 10,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 300,
          height: 50,
          child: Text('Register'),
          color: Colors.black,
          textColor: Colors.white,
          elevation: 15,
          onPressed: _onRegister,
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register', style: TextStyle(fontSize: 16))),
      ],
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
    // file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  Future<void> uploadData() async {
    ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    await pr.show();

    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    print(_image);
    if ((_image == null) ||
        (!_isEmailValid(_email)) ||
        (_password.length < 5) ||
        (_phone.length < 5)) {
      Toast.show("Invalid Registration Data", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "name": _name,
      "email": _email,
      "password": _password,
      "phone": _phone,
    }).then((res) {
      print(res.statusCode);
      print(res.body);
      _image = null;
      _namecontroller.text='';
      _emcontroller.text = '';
      _phcontroller.text = '';
      _passcontroller.text = '';
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }).catchError((err) {
      print(err);
    });
   await pr.hide();
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
