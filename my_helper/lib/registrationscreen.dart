import 'dart:io';

import 'package:flutter/material.dart';

String pathAsset = 'assets/images/splash.png';
File _image;

class MyRegistration extends StatefulWidget {
  @override
  _MyRegistrationState createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<MyRegistration> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('New Registration'),
        ),
        body: Column(
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
            Text('Click on image above to take profile picture'),
            TextField(
                //controller: _emcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                )),
            TextField(
              //controller: _passcontroller,
              decoration: InputDecoration(
                  labelText: 'Password', icon: Icon(Icons.lock)),
              obscureText: true,
            ),
            TextField(
                //controller: _phcontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Phone', icon: Icon(Icons.phone))),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
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
                child:
                    Text('Already Register', style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  void _choose() {}

  void _onRegister() {}

  void _onBackPress() {}
}
