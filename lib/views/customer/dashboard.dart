import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:miniproject/views/customer/editProfile.dart';
import 'package:miniproject/views/user/login_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(
        children: [
          const SizedBox(height: 20,), 
          Container(child: (Text('$firstname   $lastname' ,style: const TextStyle(fontSize: 20)))),    
          const SizedBox(height: 20,),      
          InkWell(
            onTap: (() => Navigator.of(context).push(
                              MaterialPageRoute(builder: (bui) => const EditProfile()))),
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(color: Colors.grey),
              child: const Text("แก้ไขข้อมูลส่วนตัว" ,style: TextStyle(fontSize: 20)),
            ),
            
          ),         
          ElevatedButton.icon(
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
