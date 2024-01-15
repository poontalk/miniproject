import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:miniproject/controller/serviceController.dart';
import 'package:miniproject/model/service.dart';
import 'package:miniproject/views/user/login_page.dart';


class ListServiceScreen extends StatefulWidget {
  const ListServiceScreen({super.key});

  @override
  State<ListServiceScreen> createState() => _ListServiceScreenState();
}

class _ListServiceScreenState extends State<ListServiceScreen> {
  final ServiceController serviceController = ServiceController();

  bool? isLoaded = false;
  List<ServiceModel>? serviceModels;
  int i = 0;
  String? userId;

  void fetchData() async {
    serviceModels = await serviceController.getListService();
    userId = await SessionManager().get("userId");
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  bool _checkLogin(){
     if(userId != null){
      return false;
    }
    return true;  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
           const SizedBox(height: 25),
              //Header
              const Text('รายการบริการ',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),       
          Expanded(
            child: ListView.builder(
                itemCount: serviceModels?.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: SizedBox(
                        width: 155,
                        child: ListTile(
                          title: Center(
                            child: Text(
                                '${serviceModels?[index].serviceName} ${serviceModels?[index].price} บาท  เวลาบริการ: ${serviceModels?[index].timespend} ชั่วโมง'),
                          ),
                        ),
                      ),
                    ),
                  );
                })),                
          ),
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible: _checkLogin(),
                  child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('คุณต้องการเข้าการงาน',
                      style: TextStyle(color: Colors.black)),
                  const SizedBox(width: 4),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent                      
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()));
                    },
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ],
              ),),           
              ],           
            )
            )
        ],
      ),
    );
  }
}
