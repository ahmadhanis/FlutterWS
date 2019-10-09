import 'package:flutter/material.dart';
import 'package:my_helper/tab_screen2.dart';
import 'package:my_helper/tab_screen3.dart';
import 'tab_screen.dart';

class MainScreen extends StatefulWidget {
  final String email;

 const MainScreen({Key key,this.email}) : super(key: key);

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
      TabScreen("Home", widget.email),
      TabScreen2("Message"),
      TabScreen3("Profile"),
    ];
  }

  String $pagetitle = "Home";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text($pagetitle),
      ),
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text("Messages"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }

  
}
