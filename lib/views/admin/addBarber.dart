import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/controller/barberController.dart';
import '../../controller/userController.dart';
import '../../model/user.dart';
import 'package:quickalert/quickalert.dart';
import 'listallmember.dart';

class AddBarber extends StatefulWidget {
  const AddBarber({super.key});

  @override
  State<AddBarber> createState() => _AddBarberState();
}

class _AddBarberState extends State<AddBarber> {

  final UserController userController = UserController();
  final BarberController barberController = BarberController();

  
    bool? isLoaded = false;
    List<UserModel>? user;

  // void addBarber(String userId) async{
  //   http.Response response = await barberController.addBarber(userId);
  //   if(response.statusCode == 200){
  //     print("success insert");
  //   }else{
  //     print("Failed insert");
  //   }
  // }

   void showSureToAddBarberAlert(String userId) {
    QuickAlert.show(
      context: context ,
      title: "เพิ่มช่างตัดผม",
      text: "ท่านต้องการเพิ่มช่างตัดผมหรือไม่",
      type: QuickAlertType.warning,
      confirmBtnText: "ตกลง",
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () async{
      http.Response response = await barberController.addBarber(userId);
        if(response.statusCode == 200){                 
          showAddBarberSuccessAlert();
        }else {
          showFailToAddBarberAlert();
        }
    },
    cancelBtnText: "ยกเลิก",
    showCancelBtn: true
    );
  }

  void showFailToAddBarberAlert () {
    QuickAlert.show(
      context: context,
      title: "ไม่สามารถเพิ่มช่างตัดผมได้",
      text: "เพราะเป็นช่างตัดผมอยู่แล้ว",    
      type: QuickAlertType.error
    );
  }

  void showAddBarberSuccessAlert () {
    QuickAlert.show(
      context: context,
      title: "สำเร็จ",
      text: "เพิ่มช่างตัดผมเสร็จสิ้น",
     type: QuickAlertType.success,
     confirmBtnText: "ตกลง",
     onConfirmBtnTap: () => Navigator.pop(context));
  }

  void fetchData () async {
    user = await userController.listAllUser();   
       setState(() {
      isLoaded = true;
    });       
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Barber'),
      ),
      backgroundColor: Colors.white,
      
      body: Column(        
        children: [ 
          const SizedBox(height: 40),     
          const  Row (
            mainAxisAlignment: MainAxisAlignment.start,
              children: [                   
                Padding(padding: EdgeInsets.only(left: 15.0)),                                  
              Text("ชื่อ"),                              
              ],             
          ),   

         Expanded(
             child: Container(
                   child: ListView.builder(        
                       itemCount: user?.length,
                       itemBuilder: ((context,index){
                       return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Card(
                         elevation: 10,
                         child: ListTile(
                leading: Text(' ${user?[index].firstName} ${user?[index].lastName} ') ,
                onTap: (){
                  print("Click at ${index}");             
                },
                                
                 trailing: GestureDetector(
                      onTap: () {
                        showSureToAddBarberAlert(user?[index].userId ?? "");                                               
                        print("Add");
                      },
                      child: const Icon(
                        Icons.add
                      ),                      
                    ),
                ),
                       ),
                    );
                  }        
                )        
              ),
            ),
         ),        
        ],    
      ),      
    );
  }
}