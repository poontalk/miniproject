import 'package:flutter/material.dart';

import 'package:miniproject/components/myTextField.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:http/http.dart' as http;

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  @override
  Widget build(BuildContext context) {

    final ServiceController serviceController = ServiceController();

    TextEditingController serviceIdController = TextEditingController();
    TextEditingController serviceNameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController timespendController = TextEditingController();

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
           ElevatedButton(
            onPressed: () async{
                http.Response response = await serviceController.addServcieModel(
                 serviceIdController.text, 
                 serviceNameController.text,
                double.parse(priceController.text) ,
                int.parse(timespendController.text)                
                );

                if (response.statusCode == 500) {
                    print("Error!");
                }  else {
                  print(serviceIdController.text);
                  print(serviceNameController.text);
                  print(priceController.text);
                  print(timespendController.text);                  
                  print("Service was added successfully");
                }           
           },
            child: Text("Add")
            )
        ],
      ),
    );
  }
}