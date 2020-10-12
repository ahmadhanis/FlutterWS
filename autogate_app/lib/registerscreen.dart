import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight, screenWidth;
  bool _isChecked = false;
  String pathAsset = 'assets/images/camera.png';
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebaseref = FirebaseDatabase.instance.reference();


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          upperHalf(context),
          lowerHalf(context),
          pageTitle(),
        ],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/login.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: screenHeight /1.6,
      margin: EdgeInsets.only(top: screenHeight / 5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(2.0),
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Registration for new user",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5),

              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _nameEditingController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus);
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                  )),
              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _emailEditingController,
                  textInputAction: TextInputAction.next,
                  focusNode: focus1,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus2);
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  )),
              TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _phoneditingController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  focusNode: focus2,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus3);
                  },
                  decoration: InputDecoration(
                    labelText: 'Mobile Phone',
                    icon: Icon(Icons.phone),
                  )),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: _passEditingController,
                textInputAction: TextInputAction.next,
                focusNode: focus3,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus4);
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool value) {
                      _onChange(value);
                    },
                  ),
                  Flexible(
                      child: GestureDetector(
                    onTap: _showEULA,
                    child: Text('I Agree to Terms  ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  )),
                  Flexible(
                      child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: screenWidth / 6,
                    height: 50,
                    child: Text('Register'),
                    color: Color.fromRGBO(101, 255, 218, 50),
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: _onRegister,
                  )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already register? ",
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  GestureDetector(
                    onTap: _loginScreen,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      //color: Color.fromRGBO(255, 200, 200, 200),
      margin: EdgeInsets.only(top: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.shopping_basket,
            size: 40,
            color: Colors.white,
          ),
          Text(
            " MY.AUTOGATE",
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }



  bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password == null || password.isEmpty) {
      return false;
    }

//  bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    // bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    return hasDigits & hasLowercase & hasMinLength;
  }

  void _onRegister() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;

    if (name.length < 5) {
      Toast.show("Name to short", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      Toast.show("Invalid Email!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    if (!isPasswordCompliant(password)) {
      Toast.show(
          "Password must be 6 characters minimum and contain lowercases and numbers",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP);
      return;
    }
    if (phone.length < 10) {
      Toast.show("Provide valid phone number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Register?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> registerUser() async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration in progress");
    await pr.show();
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    if (user != null) {
      setState(() {
        _insertUser();
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            _loginScreen();
      });
    } else {
      setState(() {
        Toast.show("Registration failed!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      });
    }

    await pr.hide();
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "EULA",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and Slumberjer This EULA agreement governs your acquisition and use of our MY.AUTOGATE software (Software) directly from Slumberjer or indirectly through a Slumberjer authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the MY.AUTOGATE software. It provides a license to use the MY.AUTOGATE software and contains warranty information and liability disclaimers. If you register for a free trial of the MY.AUTOGATE software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the MY.AUTOGATE software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Slumberjer herewith regardless of whether other software is referred to or described herein. The terms also apply to any Slumberjer updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for MY.AUTOGATE. Slumberjer shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Slumberjer. Slumberjer reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _insertUser() {
    firebaseref.child("users").once().then((DataSnapshot snapshot) {
      firebaseref
          .child("users")
          .child(encodeUserEmail(_emailEditingController.text))
          .set({
        'name': _nameEditingController.text,
        'phone': _phoneditingController.text,
      });
    });
  }

  static String encodeUserEmail(String userEmail) {
    return userEmail.replaceAll(".", ",");
  }

}
