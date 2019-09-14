import 'package:flutter/material.dart';
import 'package:food_ninja/registeruser.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

bool _isChecked = false;

class _LoginPageState extends State<LoginPage> {
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
              'assets/images/foodninjared.png',
              width: 180,
              height: 180,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress, 
                decoration: InputDecoration(
              labelText: 'Email',
            )),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              minWidth: 300,
              height: 50,
              child: Text('Login'),
              color: Colors.black,
              textColor: Colors.white,
              elevation: 15,
              onPressed: _onPress,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                ),
                Text('Remember Me',style: TextStyle(fontSize: 16))
              ],
            ),
            GestureDetector(
                onTap: _onRegister,
                child: Text('Register New Account',
                    style: TextStyle(fontSize: 16))),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: _onForgot,
                child: Text('Forgot Account', style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  void _onPress() {
    print('Press');
  }

  void _onRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterUser()));
  }

  void _onForgot() { //
    print('Forgot');
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }
}
