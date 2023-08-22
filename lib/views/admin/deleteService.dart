import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:miniproject/model/service.dart';
import 'package:miniproject/views/admin/editService.dart';
import 'package:miniproject/views/user/listService.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class DeleteServiceScreen extends StatefulWidget {
  const DeleteServiceScreen({super.key});

  @override
  State<DeleteServiceScreen> createState() => _DeleteServiceScreenState();
}

class _DeleteServiceScreenState extends State<DeleteServiceScreen> {
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

  void showSureToDeleteServiceAlert(String serviceId) {
    QuickAlert.show(
      context: context ,
      title: "ลบข้อมูลบริการ",
      text: "ท่านต้องการลบข้อมูลบริการหรือไม่",
      type: QuickAlertType.warning,
      confirmBtnText: "ลบ",
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async{
      http.Response response = await serviceController.deleteService(serviceId);

        if(response.statusCode == 200){
          Navigator.pop(context);
          showDeleteServiceSuccessAlert();
        }else {
          showFailToDeleteServiceAlert();
        }
    },
    cancelBtnText: "ยกเลิก",
    showCancelBtn: true
    );
  }

  void showFailToDeleteServiceAlert () {
    QuickAlert.show(
      context: context,
      title: "เกิดข้อมูลผิดพลาด",
      text: "ไม่สามารถลบข้อมูลบริการได้",    
      type: QuickAlertType.error
    );
  }

  void showDeleteServiceSuccessAlert () {
    QuickAlert.show(
      context: context,
      title: "สำเร็จ",
      text: "ลบข้อมูลเสร็จสิ้น",
     type: QuickAlertType.success,
     confirmBtnText: "ตกลง",
     onConfirmBtnTap: () => 
      Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (bui) => const ListServiceScreen())
                 )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Service'),
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
             trailing: GestureDetector(
                    onTap: () {
                      showSureToDeleteServiceAlert(serviceModels?[index].serviceId ?? "");
                      print("Delete");
                    },
                    child: Icon(
                      Icons.delete
                    ),
                  ),
            ),
        ),
        );
      }
      )
      ),
    );
  }
}