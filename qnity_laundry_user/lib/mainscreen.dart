import 'package:flutter/material.dart';
import 'package:qnity_laundry_user/tabscreen1.dart';

import 'tabscreen2.dart';
import 'tabscreen3.dart';

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
      TabScreen1("Request"),
      TabScreen2("History"),
      TabScreen3("Profile"),
    ];
  }

  String $pagetitle = "Qnity Laundry";

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
        type: BottomNavigationBarType.fixed ,
        
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_laundry_service,color: Color.fromRGBO(57, 195, 219, 1)),
            title: Text("Pickup"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history,color: Color.fromRGBO(57, 195, 219, 1)),
            title: Text("History"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle,color: Color.fromRGBO(57, 195, 219, 1)),
            title: Text("Profile",style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }

  
}
