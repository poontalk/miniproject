import 'package:flutter/material.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/main.dart';
import 'package:miniproject/model/service.dart';
import '../../components/validator.dart';

class EditService extends StatefulWidget {
  final String serviceId;

  const EditService({super.key, required this.serviceId});

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  ServiceModel? serviceModel;
  bool? isLoaded = false;
  

  final ServiceController serviceController = ServiceController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController serviceIdController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timespendController = TextEditingController();

  //ส่วนการใส่ข้อมูล
  void setDataToText() {
    serviceIdController.text = serviceModel?.serviceId ?? "";
    serviceNameController.text = serviceModel?.serviceName ?? "";
    priceController.text = serviceModel?.price.toString() ?? "";
    timespendController.text = serviceModel?.timespend.toString() ?? "";
  }

  //ส่วนการรับค่าข้อมูล
  void fetchData(String serviceId) async {
    serviceModel = await serviceController.getServiceById(serviceId);
    setDataToText();    
      setState(() {
        isLoaded = true;
      });    
  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.serviceId);
  }

   Future<void> _checkUpdateService(ServiceModel uService) async{
    http.Response response =
              await serviceController.editService(uService);
          if (response.statusCode == 200) {             
              showUpdateServiceSuccessAlert();                                
          }   
  }

  void showSureToUpdateServiceAlert(ServiceModel uService) {

          showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('แก้ไขสำเร็จ'),
          content: Text('แก้ไขข้อมูลการบริการเสร็จสิ้น'),
          actions:<Widget> [
               TextButton(
              onPressed: () => Navigator.pop(context, 'ยกเลิก'),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'แก้ไข'); 
                _checkUpdateService(uService); 
              } ,
              child: const Text('แก้ไข'),
            ),
          ],
        )
        );
  }

  void showUpdateServiceSuccessAlert() {  
       showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('สำเร็จ'),
          content: Text('แก้ไขข้อมูลเสร็จสิ้น'),
          actions:<Widget> [           
            TextButton(
              onPressed: () {                
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
      
            const Align(
              alignment: Alignment.center,
              child: Text('แก้ไขบริการ',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),
            ),
      
            const SizedBox(height: 10),
      
            //Box ID Service
           const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text('รหัสบริการ')],
              ),
            ),
      
            const SizedBox(height: 10),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: serviceIdController,
                enabled: false,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
            ),
      
            const SizedBox(height: 10),
      
            //Text field Name
            const SizedBox(height: 10),
            textFieldServiceName(),
      
            //Text field price
            const SizedBox(height: 10),
            textFieldPrice(),
      
            //Text field timespend
            const SizedBox(height: 10),
              Row(
              children: [
                textFieldTimespend(),
                const Text("ชั่วโมง")
              ],
            ),
            const SizedBox(height: 10),
      
            //Button Submit
            Row(mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              //ส่วนปุ่มกดแก้ไข
              ElevatedButton(
               style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: () async {
                     if(_formKey.currentState!.validate()) {
                      ServiceModel updateService = ServiceModel(
                          serviceId: serviceModel?.serviceId,
                          serviceName: serviceNameController.text,
                          price: double.parse(priceController.text),
                          timespend: int.parse(timespendController.text));                          
                            showSureToUpdateServiceAlert(updateService);
                            print('success');                                                
                    }
                  },
                  child: Text("แก้ไข")),
              const SizedBox(width: 10),
      
              //ส่วนปุ่มกดยกเลิก
              ElevatedButton(
                onPressed: () async {
                   Navigator.pop(context);
                },
                child: Text("ยกเลิก"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Padding textFieldServiceName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: serviceNameController,        
        validator: validateServiceName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ชื่อบริการ",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15), border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Padding textFieldPrice() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: priceController,
        validator: validateServicPrice,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ราคา",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15), 
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Padding textFieldTimespend() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: SizedBox(
         width: 155,
        child: TextFormField(
          keyboardType: TextInputType.number,
          maxLength: 1,
          controller: timespendController,
          validator: validateServicTimespend,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          showCursor: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: "เวลาที่ใช้",
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
             border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }
}
