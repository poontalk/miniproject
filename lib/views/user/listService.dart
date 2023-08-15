import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:miniproject/model/service.dart';
import 'package:miniproject/views/admin/editService.dart';


class ListServiceScreen extends StatefulWidget {
  const ListServiceScreen({super.key});

  @override
  State<ListServiceScreen> createState() => _ListServiceScreenState();
}

class _ListServiceScreenState extends State<ListServiceScreen> {
   final ServiceController serviceController = ServiceController();

    bool? isLoaded = false;
    List<ServiceModel>? serviceModels;

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

  void showFailToDeleteServiceAlert(){

  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Service'),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: serviceModels?.length,
        itemBuilder: ((context,index){
        return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10,
          child: ListTile(
            leading: Text('${serviceModels?[index].serviceName} ${serviceModels?[index].price} บาท'),
            onTap: (){
              print("Click at ${index}");
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditService(serviceId: serviceModels?[index].serviceId ?? "",)
              )
              );
            },
            ),
        ),
        );
      }
      )
      ),
    );
  }
}