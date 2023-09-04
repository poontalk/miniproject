import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniproject/controller/barberController.dart';
import 'package:miniproject/controller/userController.dart';
import 'package:miniproject/model/barber.dart';
import 'package:miniproject/model/user.dart';
import 'package:miniproject/views/admin/addBarber.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class ListAllMembersScreen extends StatefulWidget {
  const ListAllMembersScreen({super.key});

  @override
  State<ListAllMembersScreen> createState() => _ListAllMembersScreenState();
}

class _ListAllMembersScreenState extends State<ListAllMembersScreen> {

    final UserController userController = UserController();
    final BarberController barberController = BarberController();

    bool? isLoaded = false;
    List<UserModel>? user;
    List<BarberModel>? barber;

  void fetchData () async {
     barber = await barberController.listAllBarber();
    user = await userController.listAllBarbers();
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
  
  void showSureToBarberAlert(String barberId) {
    QuickAlert.show(
      context: context ,
      title: "ลบช่างตัดผม",
      text: "ท่านต้องการลบช่างตัดผมหรือไม่",
      type: QuickAlertType.warning,
      confirmBtnText: "ลบ",
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async{
      http.Response response = await barberController.deleteAuthorityLoginBarber(barberId);
      
        if(response.statusCode == 200){
          await barberController.deleteBarber(barberId);
          if(mounted){
             Navigator.pop(context);
          }         
          showDeleteBarberSuccessAlert();
        }else {
          showFailToDeleteBarberAlert();
        }
    },
    cancelBtnText: "ยกเลิก",
    showCancelBtn: true
    );
  }

  void showFailToDeleteBarberAlert () {
    QuickAlert.show(
      context: context,
      title: "เกิดข้อมูลผิดพลาด",
      text: "ไม่สามารถลบช่างตัดผมได้",    
      type: QuickAlertType.error
    );
  }

  void showDeleteBarberSuccessAlert () {
    QuickAlert.show(
      context: context,
      title: "สำเร็จ",
      text: "ลบช่างตัดผมเสร็จสิ้น",
     type: QuickAlertType.success,
     confirmBtnText: "ตกลง",
     onConfirmBtnTap: () => 
      Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (bui) => const ListAllMembersScreen())
                 )
      );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text('List All Members'),
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
                               Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBarber()));                        
                             },
                              child: const Text("เพิ่มช่างตัดผม")
                              ),
                ),
          ],
          ),   
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [                           
              Text("ชื่อ"),             
              Text("สถานะ"),              
              ],
              
          ),   

         Expanded(
             child: Container(
                   child: ListView.builder(        
                       itemCount: barber?.length ?? user?.length,
                       itemBuilder: ((context,index){
                       return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Card(
                         elevation: 10,
                         child: ListTile(
                leading: Text('${barber?[index].barberId}    ${user?[index].firstName}        ${user?[index].lastName}    ${barber?[index].barberStatus}') ,
                                
                 trailing: GestureDetector(
                      onTap: () {
                        showSureToBarberAlert(barber?[index].barberId ?? "");                     
                        
                      },
                      child: const Icon(
                        Icons.delete
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