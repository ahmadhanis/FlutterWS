import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qnity_laundry_user/mainscreen.dart';
import 'loginscreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

String urlUpload = "http://slumberjer.com/qnity/php/register_user.php";
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
String _name, _email, _password, _phone;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text('New User Registration'),
            backgroundColor: Color.fromRGBO(57, 195, 219, 1)),
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
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("WELCOME",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
        SizedBox(
          height: 15,
        ),
        Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _emcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(
                        Icons.email,
                        color: Color.fromRGBO(57, 195, 219, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                      controller: _namecontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(Icons.person,
                            color: Color.fromRGBO(57, 195, 219, 1)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _passcontroller,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock,
                            color: Color.fromRGBO(57, 195, 219, 1))),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                      controller: _phcontroller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Phone', icon: Icon(Icons.phone))),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 300,
                    height: 50,
                    child: Text('Register'),
                    color: Color.fromRGBO(57, 195, 219, 1),
                    textColor: Colors.white,
                    elevation: 15,
                    onPressed: _onRegister,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                      onTap: _onBackPress,
                      child: Text('Already Register',
                          style: TextStyle(fontSize: 16))),
                ],
              ),
            )),
      ],
    );
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    uploadData();
  }

  void _onBackPress() {
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_phone.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      http.post(urlUpload, body: {
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
      }).then((res) {
        print(res.statusCode);
        if (res.statusCode == 200 && res.body == "success") {
          savepref();
          Toast.show("Success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          // _namecontroller.text = '';
          // _emcontroller.text = '';
          // _phcontroller.text = '';
          // _passcontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }else{
          Toast.show("Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
           pr.dismiss();
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref() async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _name = _namecontroller.text;
    _phone = _phcontroller.text;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _email);
    await prefs.setString('pass', _password);
    await prefs.setString('name', _name);
    await prefs.setString('phone', _phone);
  }
}
