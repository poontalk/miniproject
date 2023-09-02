import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/controller/barberController.dart';
import '../../controller/userController.dart';
import '../../model/user.dart';

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

  void addBarber(String userId) async{
    http.Response response = await barberController.addBarber(userId);
    if(response.statusCode == 200){
      print("success insert");
    }else{
      print("Failed insert");
    }
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
                        //showSureToDeleteServiceAlert(serviceModels?[index].serviceId ?? "");
                        addBarber(user?[index].userId ?? "");                        
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