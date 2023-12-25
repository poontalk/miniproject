import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/controller/barberController.dart';
import 'package:miniproject/main.dart';
import '../../controller/userController.dart';
import '../../model/user.dart';
import 'package:quickalert/quickalert.dart';


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

  Future<void> _checkAddBarber(String userId) async{
    http.Response response =
              await barberController.addBarber(userId);        
          if (response.statusCode == 200) {    
            showAddBarberSuccessAlert();
          } else {
            showFailToAddBarberAlert();
          }
  }

   void showSureToAddBarberAlert(String userId) {
        showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('เพิ่มช่างตัดผม'),
          content: Text('ท่านต้องการเพิ่มช่างตัดผมหรือไม่'),
          actions:<Widget> [
               TextButton(
              onPressed: () => Navigator.pop(context, 'ยกเลิก'),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'เพิ่ม'); 
                _checkAddBarber(userId);
              } ,
              child: const Text('เพิ่ม'),
            ),
          ],
        )
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
    showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('สำเร็จ'),
          content: Text('เพิ่มช่างตัดผมเสร็จสิ้น'),
          actions:<Widget> [           
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'ตกลง'); 
                Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MyApp()));                 
              } ,
              child: const Text('ตกลง'),
            ),
          ],
        )
        ); 
  }

  void fetchData () async {
    String role = "barber";
    String role2 = "admin";
    user = await userController.listAllCustomer(role,role2);   
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
        backgroundColor: Colors.grey[200],
        title: const Text('Add Barber'),
      ),
      backgroundColor: Colors.grey[300],
      
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
                        color: Colors.blue[200],
                         elevation: 10,
                         child: ListTile(
                title: Text(' ${user?[index].firstName} ${user?[index].lastName} ') ,
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