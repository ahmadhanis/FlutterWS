import 'package:flutter/material.dart';
import 'package:my_helper/tab_screen2.dart';
import 'package:my_helper/tab_screen3.dart';
import 'package:my_helper/tab_screen4.dart';
import 'package:my_helper/user.dart';
import 'tab_screen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(user: widget.user),
      TabScreen2(user: widget.user),
      TabScreen3(user: widget.user),
      TabScreen4(user: widget.user),
    ];
  }

  String $pagetitle = "My Helper";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Posted Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("My Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
