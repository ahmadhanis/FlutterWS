import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _isChecked = true;
final TextEditingController _emcontroller = TextEditingController();
String _email = "";
final TextEditingController _pscontroller = TextEditingController();
String _pass = "";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/splash.png',
              scale: 2.5,
            ),
            TextField(
                controller: _emcontroller,
                decoration: InputDecoration(
                  labelText: 'Email',
                )),
            TextField(
              controller: _pscontroller,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                ),
                Text('Remember Me', style: TextStyle(fontSize: 16))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: 300,
              height: 50,
              child: Text('Login'),
              color: Color.fromRGBO(159, 30, 99, 1),
              textColor: Colors.white,
              elevation: 20,
              onPressed: _onPress,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Register new account"),
            SizedBox(
              height: 10,
            ),
            Text('Forgot password')
          ],
        ),
      ),
    );
  }

  void _onPress() {
    print(_emcontroller.text);
    print(_pscontroller.text);
    if (_checkEmail(_emcontroller.text)) {
      return;
    } else {
      print("Success Login");
    }
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      print('Check value $value');
      _savePref(value);
    });
  }

  bool _checkEmail(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }

  void _savePref(bool value) async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _pass = _pscontroller.text;
    if (value) {
      if (_checkEmail(_email)) {
        //Store value in pref
        await prefs.setString('email', _email);
        await prefs.setString('pass', _pass);
        print('Pref Stored');
      } else {
        print('email invalid!!!');
        setState(() {
          _isChecked = false;
        });
      }
    } else {
      //Remove value from pref
       await prefs.setString('email', '');
       await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _pscontroller.text = '';
        _isChecked = false;
      });
      print('pref removed');
    }
  }

  void _loadpref() async{
    print('inside loadpref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _pass = (prefs.getString('pass'));
    print(_email);
    print(_pass);
    if (_email.length>1){
      _emcontroller.text = _email;
      _pscontroller.text = _pass;
      setState(() {
        _isChecked = true;
      });
    }else{
      setState(() {
        _isChecked = false;
      });
    }
  }
}