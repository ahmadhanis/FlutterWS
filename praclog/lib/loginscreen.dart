import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:praclog/svrscreen.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'mainscreen.dart';
import 'registerscreensvr.dart';
import 'user.dart';
import 'package:praclog/registerscreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight, screenWidth;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  String urlLogin = "https://slumberjer.com/prak/php/login_user.php";
  String urlLoginSvr = "https://slumberjer.com/prak/php/login_svr.php";
  bool rememberMe = false;
  String selectedUser = "Student";
  List<String> userType = ["Student", "Supervisor"];
  final focus = FocusNode();
  final focus1 = FocusNode();

  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    this.loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
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
      height: screenHeight / 1.5,
      margin: EdgeInsets.only(top: screenHeight / 3.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      )),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: _passEditingController,
                    textInputAction: TextInputAction.done,
                    focusNode: focus,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.accountGroup,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      SizedBox(width: 20),
                      DropdownButton(
                        //sorting dropdownoption
                        hint: Text(
                          'Please select user type',
                          style: TextStyle(
                            color: Color.fromRGBO(101, 255, 218, 50),
                          ),
                        ), // Not necessary for Option 1
                        value: selectedUser,
                        onChanged: (newValue) {
                          setState(() {
                            selectedUser = newValue;
                            print(selectedUser);
                          });
                        },
                        items: userType.map((selectedUser) {
                          return DropdownMenuItem(
                            child: new Text(selectedUser,
                                style: TextStyle(
                                    color: Color.fromRGBO(101, 255, 218, 50))),
                            value: selectedUser,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onRememberMeChanged(value);
                        },
                      ),
                      Text('Remember Me ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: screenWidth / 4.5,
                        height: 50,
                        child: Text('Login',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () => _onLoginOption(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account? ",
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              GestureDetector(
                onTap: _onCreateAccOption,
                child: Text(
                  "Create Account",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Forgot your password ",
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              GestureDetector(
                onTap: _forgotPassword,
                child: Text(
                  "Reset Password",
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
            Icons.book,
            size: 40,
            color: Colors.white,
          ),
          Text(
            " MY.LOGBOOK",
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

  void _userLogin() async {
    String _email = _emailEditingController.text;
    String _password = _passEditingController.text;
    print(_password);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if (!emailValid) {
      Toast.show("Invalid Email!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    if (!isPasswordCompliant(_password)) {
      Toast.show(
          "Password must be 6 characters minimum and contain lowercases and numbers",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP);
      return;
    }

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Log in...");
    await pr.show();
    http
        .post(urlLogin, body: {
          "email": _email,
          "password": _password,
        })
        .timeout(const Duration(seconds: 10))
        .then((res) {
          print(res.body);
          var string = res.body;
          List userdata = string.split(",");
          if (userdata[0] == "success") {
            User _user = new User(
                name: userdata[1],
                email: _email,
                password: _password,
                phone: userdata[2],
                company: userdata[3],
                supervisor: userdata[4],
                matric: userdata[5]);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(
                          user: _user,
                        )));
          } else {
            Toast.show("Login failed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
          }
        })
        .catchError((err) {
          print(err);
          Toast.show("Error:" + err.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        });
    await pr.hide();
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _registerSvr() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RegisterScreenSvr()));
  }

  void _forgotPassword() {
    TextEditingController emailController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Forgot Password? Enter your recovery email",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: new Container(
            height: screenHeight / 10,
            child: SingleChildScrollView(
                child: TextField(
                    controller: emailController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                    ))),
          ),
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
                _resetPassword(emailController.text);
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

  void _onRememberMeChanged(bool newValue) {
    if (_emailEditingController.text == "" &&
        _passEditingController.text == "") {
      Toast.show("Email/password empty!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      return;
    }
    setState(() {
      rememberMe = newValue;
      print(rememberMe);
      if (rememberMe) {
        savepref(true);
      } else {
        savepref(false);
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    String type = (prefs.getString('usertype')) ?? 'Student';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        rememberMe = true;
        selectedUser = type;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setString('usertype', selectedUser);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setString('usertype', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
    }
  }

  _resetPassword(String em) {
    http
        .post("https://slumberjer.com/prak/php/verify_email.php", body: {
          "email": em,
        })
        .timeout(const Duration(seconds: 10))
        .then((res) {
          print(res.body);
          if (res.body == "success") {
            Toast.show(
                "Success. Check your email (check your spam folder)", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
          } else {
            Toast.show("Reset password failed.", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
          }
        })
        .catchError((err) {
          print(err);
          Toast.show("Error:" + err.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        });
  }

  _lectLogin() async {
    String _email = _emailEditingController.text;
    String _password = _passEditingController.text;
    print(_password);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if (!emailValid) {
      Toast.show("Invalid Email!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    if (!isPasswordCompliant(_password)) {
      Toast.show(
          "Password must be 6 characters minimum and contain lowercases and numbers",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP);
      return;
    }

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Log in...");
    await pr.show();

    http
        .post(urlLoginSvr, body: {
          "email": _email,
          "password": _password,
        })
        .timeout(const Duration(seconds: 10))
        .then((res) {
          print(res.body);
          var string = res.body;
          List userdata = string.split(",");
          if (userdata[0] == "success") {
            User _user = new User(
                name: userdata[1],
                email: _email,
                password: _password,
                matric: userdata[2]);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SvrScreen(
                          user: _user,
                        )));
          } else {
            Toast.show(
              "Login failed",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.TOP,
            );
          }
        })
        .catchError((err) {
          print(err);
          Toast.show("Error:" + err.toString(), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        });
    await pr.hide();
  }

  _onLoginOption() {
    if (selectedUser == "Student") {
      _userLogin();
    }
    if (selectedUser == "Supervisor") {
      _lectLogin();
    }
  }

  _onCreateAccOption() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Create account as:",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        //minWidth: screenWidth / 5,
                        height: 100,
                        child: Text('Students',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _registerUser()},
                      )),
                      SizedBox(width: 10),
                      Expanded(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        //minWidth: screenWidth / 5,
                        height: 100,
                        child: Text('Supervisor',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _registerSvr(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  // _onForgotOption() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //           //backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //           content: new Container(
  //             //color: Colors.white,
  //             height: screenHeight / 4,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: <Widget>[
  //                 Container(
  //                     child: Text(
  //                   "Retreive as:",
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 16),
  //                 )),
  //                 SizedBox(height: 5),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     MaterialButton(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(5.0)),
  //                       minWidth: 100,
  //                       height: 100,
  //                       child: Text('Students',
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                           )),
  //                       color: Color.fromRGBO(101, 255, 218, 50),
  //                       textColor: Colors.white,
  //                       elevation: 10,
  //                       onPressed: () => {
  //                         Navigator.pop(context),
  //                         _forgotPassword("STUDENT")
  //                       },
  //                     ),
  //                     SizedBox(width: 10),
  //                     MaterialButton(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(5.0)),
  //                       minWidth: 100,
  //                       height: 100,
  //                       child: Text('Supervisor',
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                           )),
  //                       color: Color.fromRGBO(101, 255, 218, 50),
  //                       textColor: Colors.white,
  //                       elevation: 10,
  //                       onPressed: () => {
  //                         Navigator.pop(context),
  //                         _forgotPassword("SUPERVISOR"),
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ));
  //     },
  //   );
  // }
}
