import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miniproject/components/myTextField.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/main.dart';
import 'package:miniproject/model/service.dart';
import 'package:miniproject/views/user/listService.dart';
import 'package:quickalert/quickalert.dart';

class EditService extends StatefulWidget {
  final String serviceId;

  const EditService({super.key,
  required this.serviceId});

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {

  ServiceModel? serviceModel;
  bool? isLoaded = false;
 

  final ServiceController serviceController = ServiceController();

  TextEditingController serviceIdController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timespendController = TextEditingController();

  void setDataToText(){
    serviceIdController.text = serviceModel?.serviceId ?? "";
    serviceNameController.text = serviceModel?.serviceName ?? "";
    priceController.text = serviceModel?.price.toString() ?? "";
    timespendController.text = serviceModel?.timespend.toString() ?? "";
  }

  void fetchData(String serviceId) async {
    serviceModel = await serviceController.getServiceById(serviceId);
    setDataToText();
    setState(() {
      isLoaded = true;
    });
  }

  void showSureToUpdateServiceAlert(ServiceModel uService) {
    QuickAlert.show(
      context: context ,
      title: "แก้ไขสำเร็จ",
      text: "แก้ไขข้อมูลการบริการเสร็จสิ้น",
      type: QuickAlertType.warning,
      confirmBtnText: "แก้ไข",
      onConfirmBtnTap: () async{
      http.Response response = await serviceController.updateService(uService);

        if(response.statusCode == 200){
          Navigator.pop(context);
          showUpdateServiceSuccessAlert();
        }else {

        }
    },
    cancelBtnText: "ยกเลิก",
    showCancelBtn: true
    );
  }

  void showUpdateServiceSuccessAlert () {
    QuickAlert.show(
      context: context,
      title: "สำเร็จ",
      text: "แก้ไขข้อมูลเสร็จสิ้น",
     type: QuickAlertType.success,
     confirmBtnText: "ตกลง",
     onConfirmBtnTap: () => 
      Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (bui) => ListServiceScreen())
                 )
      );
  }

  @override
  void initState(){
    super.initState();
    fetchData(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {

    
   
    
     return Scaffold(     
      body: Column(
        children: [
          SizedBox(height: 30,),
          Align(
            alignment: Alignment.center,
            child: Text('เพิ่มบริการ',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 30)
            ),            
          ),

          SizedBox(height: 50,),

          //Box ID Service 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('รหัสบริการ')
              ],
            ),
          ),      

          SizedBox(height: 10,),

           MyTextField(controller: serviceIdController, hintText: '', obcureText: false),

          SizedBox(height: 10,),

          //Box Name Service
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('ชื่อบริการ')
              ],
            ),
          ),

          SizedBox(height: 10,),

          MyTextField(controller: serviceNameController, hintText: '', obcureText: false),

          //Box Price Service
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('ราคา')
              ],
            ),
          ),

          SizedBox(height: 10,),

          MyTextField(controller: priceController, hintText: '', obcureText: false),

          //Box TimeSpend Service
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('เวลาที่ใช้')
              ],
            ),
          ),

          SizedBox(height: 10,),

          MyTextField(controller: timespendController, hintText: '', obcureText: false),


          SizedBox(height: 10,),
          
          //Button Submit
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
             children:[
              ElevatedButton(
              onPressed: () async{
                  ServiceModel updateService = ServiceModel(
                    serviceId: serviceModel?.serviceId, 
                    serviceName: serviceNameController.text,
                    price: double.parse(priceController.text) ,
                    timespend: int.parse(timespendController.text) 
                  );                       
                 showSureToUpdateServiceAlert(updateService);
                                        
             },
              child: Text("แก้ไข")
              ),

              SizedBox(
              width: 10,
            ),

             ElevatedButton(
            onPressed: () async{
                 Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (bui) => MyApp())
                 );
           },
            child: Text("ยกเลิก"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            ),
             ] 
           )
        ],
      ),
    );
  }
}