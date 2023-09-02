import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniproject/controller/userController.dart';
import 'package:miniproject/model/user.dart';
import 'package:miniproject/views/admin/addBarber.dart';

class ListAllMembersScreen extends StatefulWidget {
  const ListAllMembersScreen({super.key});

  @override
  State<ListAllMembersScreen> createState() => _ListAllMembersScreenState();
}

class _ListAllMembersScreenState extends State<ListAllMembersScreen> {

    final UserController userController = UserController();

    bool? isLoaded = false;
    List<UserModel>? user;

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
                       itemCount: user?.length,
                       itemBuilder: ((context,index){
                       return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Card(
                         elevation: 10,
                         child: ListTile(
                leading: Text(' ${user?[index].firstName} ${user?[index].lastName} ') ,
                                
                 trailing: GestureDetector(
                      onTap: () {
                        user?[index].userId ?? "";
                        print("Delete");
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