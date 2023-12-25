import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:miniproject/views/admin/reportsummary.dart';

import '../customer/editProfile.dart';
import '../user/login_page.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  var sessionManager = SessionManager();
  bool? isLoaded = false;
  String? firstname;
  String? lastname;
  dynamic username;

  void _fetchData() async {
    firstname = await SessionManager().get("firstname");
    lastname = await SessionManager().get("lastname");
    username = await SessionManager().get("username");
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(    
      backgroundColor: Colors.grey[300], 
      body: Column(
        children: [
          const SizedBox(height: 30,), 
          Container(child: (Text('$firstname   $lastname' ,style: const TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold)))),    
          const SizedBox(height: 30,),      
          InkWell(
            onTap: (() => Navigator.of(context).push(
                              MaterialPageRoute(builder: (bui) => const EditProfile()))),
            child: Container(
              margin: EdgeInsets.only(left: 10.0 ,right: 10.0),
              height: 50,
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey ,width: 1.0))),
              child: const Text("แก้ไขข้อมูลส่วนตัว" ,style: TextStyle(fontSize: 20)),
            ),
            
          ),
          const SizedBox(height: 10), 
            InkWell(
            onTap: (() => Navigator.of(context).push(
                              MaterialPageRoute(builder: (bui) => const ReportSummaryIncome()))),
            child: Container(    
              margin: EdgeInsets.only(left: 10.0 ,right: 10.0),          
              height: 50,
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey ,width: 1.0))),
              child: const Text("รายงานรายได้รวม" ,style: TextStyle(fontSize: 20)),
            ),
            
          ),       
          const SizedBox(height: 20),    
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () async {
                firstname = await SessionManager().remove("firstname");
                username = await SessionManager().remove("username");
                await SessionManager().remove("lastname");
                await SessionManager().remove("roles");
                await SessionManager().remove("userId");
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (bui) => LoginPage()));
                  if (firstname == null) {
                    print('Sucess remove');
                  }
                }
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'))
        ],
      ),
    );
  }
}