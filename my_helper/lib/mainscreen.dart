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
      TabScreen2("MyJobs"),
      TabScreen2("Message"),
      TabScreen3("Profile"),
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
    return Scaffold(
     // appBar: AppBar(
     //   title: Text($pagetitle),
     // ),
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed ,
        
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: Color.fromARGB(255, 0, 0, 0)),
            title: Text("Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event,color: Color.fromARGB(255, 0, 0, 0)),
            title: Text("My Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail,color: Color.fromARGB(255, 0, 0, 0)),
            title: Text("Messages",style: TextStyle(color: Colors.black),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Color.fromARGB(255, 0, 0, 0)),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }

  
}
