import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:miniproject/views/admin/addService.dart';
import 'package:miniproject/views/admin/deleteService.dart';
import 'package:miniproject/views/admin/editShopProfile.dart';
import 'package:miniproject/views/admin/listallmember.dart';
import 'package:miniproject/views/user/listService.dart';
import 'package:miniproject/views/user/login_page.dart';
import 'package:miniproject/views/user/register_page.dart';
import 'package:miniproject/views/customer/reserveService_page.dart';

import 'package:google_nav_bar/google_nav_bar.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
    int i =0;
   int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  final List<Widget> _widgetOptions = <Widget> [   
     const ListAllMembersScreen(),
     const ListServiceScreen(),
     LoginPage(),
     registerPage(),   
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(        
        body: Center(child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
            )
          ],
          ),
          child: SafeArea(
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 15 ,vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.redAccent,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: "หน้าหลัก",
                ),
                GButton(
                  icon: LineIcons.list,
                  text: "รายการบริการ",
                ),
                GButton(
                  icon: LineIcons.calendar,
                  text: "นัดจอง",
                ),
                GButton(
                  icon: LineIcons.userCircle,
                  text: "โปร์ไฟล์",
                )
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index){
                setState(() {
                  _selectedIndex = index;
                });
              },
              ),
              )
            ),
        ),
      ),
    );
  }
}

 


