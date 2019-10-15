import 'package:flutter/material.dart';
import 'package:my_helper/mainscreen.dart';
 
class NewJob extends StatefulWidget {
final String email;
const NewJob({Key key,this.email}) : super(key: key);

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
          title: Text('Request new help'),
        ),
        body: SingleChildScrollView(
           child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Text("Register"),
          ),
        )
       ),
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