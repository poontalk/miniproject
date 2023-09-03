import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/controller/barberController.dart';
import '../../controller/userController.dart';
import '../../model/user.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

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
          if(mounted){
             Navigator.pop(context);
          }         
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
      title: "เกิดข้อมูลผิดพลาด",
      text: "ไม่สามารถเพิ่มช่างตัดผมได้",    
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
     onConfirmBtnTap: () => 
      Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (bui) => const ListAllMembersScreen())
                 )
      );
  }

  void fetchData () async {
    user = await userController.listAllUser();
    if(mounted){
       setState(() {
      isLoaded = true;
    });
    }   
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 5),
                  child: ElevatedButton(style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  primary: Colors.yellow, onPrimary: Colors.black,
                  side: const BorderSide(
                    width: 2,
                    color: Colors.black
                  )),    
                                
                              onPressed: () {                 
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteServiceScreen()));                        
                             },
                              child: const Text("เพิ่มช่างตัดผม")
                              ),
                ),
          ],
          ),   
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [                           
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
             /* Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditService(userId: user()?[index].serviceId ?? "",) )
              );*/
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