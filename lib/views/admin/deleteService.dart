import 'package:flutter/material.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:miniproject/model/service.dart';
import 'package:miniproject/views/admin/addService.dart';
import 'package:miniproject/views/admin/editService.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class DeleteServiceScreen extends StatefulWidget {
  const DeleteServiceScreen({super.key});

  @override
  State<DeleteServiceScreen> createState() => _DeleteServiceScreenState();
}

class _DeleteServiceScreenState extends State<DeleteServiceScreen> {
  final ServiceController serviceController = ServiceController();

  bool? isLoaded = false;
  List<ServiceModel>? serviceModels;
  //ส่วนรับค่าจาก servicemodels
  void fetchData() async {
    serviceModels = await serviceController.getListService();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _checkDeleteService(String serviceId) async{
    http.Response response =
              await serviceController.doDeleteService(serviceId);          
          if (response.statusCode == 200) {            
            showDeleteServiceSuccessAlert();
          } else {
            showFailToDeleteServiceAlert();
          }
  }

  void showSureToDeleteServiceAlert(String serviceId) {     
        showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('ลบข้อมูลบริการ'),
          content: Text('ท่านต้องการลบข้อมูลบริการหรือไม่'),
          actions:<Widget> [
               TextButton(
              onPressed: () => Navigator.pop(context, 'ยกเลิก'),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'ใช่'); 
                _checkDeleteService(serviceId);
              } ,
              child: const Text('ใช่'),
            ),
          ],
        )
        );     
     
  }

  //ส่วน method การลบผิดพลาด
  void showFailToDeleteServiceAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อมูลผิดพลาด",
        text: "ไม่สามารถลบข้อมูลบริการได้",
        type: QuickAlertType.error);
  }
  
  //ส่วน method การลบสำเร็จ
  void showDeleteServiceSuccessAlert() { 
      showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('สำเร็จ'),
          content: Text('ลบข้อมูลเสร็จสิ้น'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const SizedBox(height: 30),
           const Align(
              alignment: Alignment.center,
              child: Text('รายการบริการ',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),
            ),
          //ส่วน ปุ่มกดเพิ่มบริการ
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        side: const BorderSide(width: 2, color: Colors.black)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddService()));
                    },
                    child: const Text("เพิ่มบริการ")),
              ),
            ],
          ),
          //ส่วน ชื่อบริการและราคา
          Expanded(
            child: ListView.builder(
                itemCount: serviceModels?.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.blue[200],
                      elevation: 10,
                      child: ListTile(
                        title: Text(
                            '${serviceModels?[index].serviceName} ${serviceModels?[index].price} บาท'),
                        onTap: () {
                          print("Click at ${index}");
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => EditService(
                                        serviceId:
                                            serviceModels?[index].serviceId ??
                                                "",
                                      )));
                        },
                        trailing: GestureDetector(
                          onTap: () {                            
                            showSureToDeleteServiceAlert(
                                serviceModels?[index].serviceId ?? "");
                            print("Delete");
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }
}
