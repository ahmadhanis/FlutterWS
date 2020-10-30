import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//import 'mainscreen.dart';
//import 'user.dart';
import 'loginscreen.dart';
//import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.anaheimTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'MyLogBook',
      home: Scaffold(
          body: Container(
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/splash.png'),
                        fit: BoxFit.cover))),
            Container(height: 300, child: ProgressIndicator()),
            pageTitle(),
          ],
        ),
      )),
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
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            controller.stop();
            //loadpref(this.context);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      //width: 300,
      child: CircularProgressIndicator(
        value: animation.value,
        //backgroundColor: Colors.brown,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    ));
  }
 

  // void loadpref(BuildContext ctx) async {
  //   print('Inside loadpref()');

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = (prefs.getString('email') ?? '');
  //   String pass = (prefs.getString('pass') ?? '');
  //   print("Splash:Preference" + email + "/" + pass);
  //   if (email.length > 5) {
  //     //login with email and password
  //     loginUser(email, pass, ctx);
  //   } else {
  //     registerNew();
  //   }
  // }

  void registerNew() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  // void loginUser(String email, String pass, BuildContext ctx) {
  //   http
  //       .post("https://slumberjer.com/prak/php/login_user.php", body: {
  //         "email": email,
  //         "password": pass,
  //       })
  //       .timeout(const Duration(seconds: 10))
  //       .then((res) {
  //         print(res.body);
  //         var string = res.body;
  //         List userdata = string.split(",");
  //         if (userdata[0] == "success") {
  //           // User _user = new User(
  //           //     name: userdata[1],
  //           //     email: email,
  //           //     password: pass,
  //           //     phone: userdata[2],
  //           //     company: userdata[3]);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (BuildContext context) => LoginScreen()));
  //           // Navigator.pushReplacement(
  //           //     context,
  //           //     MaterialPageRoute(
  //           //         builder: (BuildContext context) => MainScreen(
  //           //               user: _user,
  //           //             )));
  //           //this.dispose();
  //         } else {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (BuildContext context) => LoginScreen()));
  //           // Toast.show(
  //           //     "Fail to login with stored credential. Login as unregistered account.",
  //           //     context,
  //           //     duration: Toast.LENGTH_LONG,
  //           //     gravity: Toast.TOP);
  //         }
  //       })
  //       .catchError((err) {
  //         print(err);
  //         Toast.show("Error: " + err.toString(), context,
  //             duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => LoginScreen()));
  //       });
  // }
}
