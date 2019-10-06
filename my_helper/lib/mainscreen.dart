import 'package:flutter/material.dart';
import 'package:my_helper/tab_screen2.dart';
import 'tab_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen() : super();

  //final String title = "Home";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;
  List<Widget> tabs = [
    TabScreen(Colors.green, "Home"),
    TabScreen2(Colors.orange, "Message"),
    TabScreen(Colors.blue, "Profile")
  ];

  String $pagetitle="Home";
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
            icon: Icon(Icons.home),
            title: Text("Home"),
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
