import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:miniproject/model/user.dart';
import 'package:miniproject/views/admin/deleteService.dart';
import 'package:miniproject/views/admin/editShopProfile.dart';
import 'package:miniproject/views/admin/listallmember.dart';
import 'package:miniproject/views/barber/listReserve.dart';
import 'package:miniproject/views/customer/cancelService.dart';
import 'package:miniproject/views/customer/dashboard.dart';
import 'package:miniproject/views/customer/editProfile.dart';
import 'package:miniproject/views/customer/listReserve.dart';
import 'package:miniproject/views/user/login_page.dart';
import 'package:miniproject/views/customer/reserveService_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();   
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _openUserName().toString() != ' ' ? LoginPage() : MyApp()));
  // runApp(MyApp());
}

Future<dynamic> _openUserName() async {
  dynamic username = await SessionManager().get("username");
  print(username);
  return username;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
 
class _MyAppState extends State<MyApp> {
  var sessionManager = SessionManager();
  int i = 0;
  int _selectedIndex = 0;
  dynamic role;  
  bool? isLoaded = false;
  UserModel? userModel;
  
    final List<Widget> _widgetAdmin = <Widget>[
      const ListAllMembersScreen(),
      DeleteServiceScreen(),
      EditShopProfile(),
      const DashboardScreen(),
    ];

    final List<Widget> _widgetBarber = <Widget>[      
      const ListReserveBarber(),
      EditProfile(),                 
      const DashboardScreen(),
    ];

     final List<Widget> _widgetCustomer = <Widget>[       
      ReserveSerivePage(),  
      CancelServicePage(),  
      ListReserveCustomer(),             
      const DashboardScreen(),
    ];

 
  Future<dynamic> _openRole() async {
    role = await sessionManager.get("roles");
    if(mounted){
      setState(() {       
        isLoaded = true;      
      }); 
    }      
     return role;
  }
 @override
  void initState() {
    if(mounted){
      super.initState();
      _openRole();
    }    
  }

  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: 
                 role.toString() == "barber" ? _widgetBarber.elementAt(_selectedIndex) : 
                 role.toString() == "customer" ? _widgetCustomer.elementAt(_selectedIndex) :
                  _widgetAdmin.elementAt(_selectedIndex)
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: 
            role.toString() == "barber" ?  _bottomNavBarber() : 
            role.toString() == "admin" ? _bottomNavAdmin():              
            _bottomNavCustomer()
          )),
        ),
      ),
    );    
  }

   GNav _bottomNavBarber() {
    return GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.redAccent,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [                
              GButton(
                icon: LineIcons.calendar,
                text: "รายการการจอง",
              ),             
              GButton(
                icon: LineIcons.userCircle,
                text: "โปร์ไฟล์",
              ),
               GButton(
                icon: LineIcons.home,               
              ),  
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              if(mounted){
                setState(() {
                _selectedIndex = index;
              });
              }              
            },
          );
  } 

   GNav _bottomNavAdmin() {
    return GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.redAccent,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [                
              GButton(
                icon: LineIcons.home,
                text: "รายชื่อช่าง",
              ),
              GButton(
                icon: LineIcons.list,
                text: "รายการบริการ",
              ),
              GButton(
                icon: LineIcons.shoppingBag,
                text: "ร้าน",
              ),
              GButton(
                icon: LineIcons.userCircle,
                text: "โปร์ไฟล์",
              )
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              if(mounted){
                 setState(() {
                _selectedIndex = index;
              });
              }             
            },
          );
  } 

  GNav _bottomNavCustomer() {
    return GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.redAccent,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [     
               GButton(
                icon: LineIcons.calendar,
                text: "นัดจอง",
              ),           
              GButton(
                icon: LineIcons.home,
                text: "ยกเลิกบริการ",
              ),
              GButton(
                icon: LineIcons.list,
                text: "รายการการจอง",
              ),
             
              GButton(
                icon: LineIcons.userCircle,
                text: "โปร์ไฟล์",
              )
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              if(mounted){
                setState(() {
                _selectedIndex = index;
              });
              }              
            },
          );
  } 
  
}
