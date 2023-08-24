import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:miniproject/model/service.dart';
import 'package:miniproject/views/admin/deleteService.dart';
import 'package:miniproject/views/admin/editService.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:miniproject/views/user/register_page.dart';
import '../../main.dart';
import '../admin/listallmember.dart';
import 'login_page.dart';


class ListServiceScreen extends StatefulWidget {
  const ListServiceScreen({super.key});

  @override
  State<ListServiceScreen> createState() => _ListServiceScreenState();
}

class _ListServiceScreenState extends State<ListServiceScreen> {
   final ServiceController serviceController = ServiceController();

    bool? isLoaded = false;
    List<ServiceModel>? serviceModels;

      int i =0;
   int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  final List<Widget> _widgetOptions = <Widget> [   
     const ListAllMembersScreen(),
     const ListServiceScreen(),
     LoginPage(),
     registerPage(),   
  ];

  void fetchData () async {
    serviceModels = await serviceController.listAllService();    
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
        title: const Text('List Service'),
      ),
      backgroundColor: Colors.white,
      
      body: Column( 
       
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  primary: Colors.yellow, onPrimary: Colors.black,
                  side: const BorderSide(
                    width: 2,
                    color: Colors.black
                  )),    
                              onPressed: () {                 
                               Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteServiceScreen()));                        
                             },
                              child: const Text("Delete")
                              ),
                ),
          ],
          ),      

         Expanded(
             child: ListView.builder(        
          itemCount: serviceModels?.length,
          itemBuilder: ((context,index){
          return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            child: ListTile(
              leading: Text('${serviceModels?[index].serviceName} ${serviceModels?[index].price} บาท'),
              ),
          ),
          );
        }        
        )        
        ),
         ),
         Row(
          children: [
            
          ],
         )
        ],         
     
      ),          
    );
  }
}