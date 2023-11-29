import 'package:flutter/material.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/main.dart';
import '../../components/validator.dart';


class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final ServiceController serviceController = ServiceController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController serviceIdController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timespendController = TextEditingController();

 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
      
            const Align(
              alignment: Alignment.center,
              child: Text('เพิ่มบริการ',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),
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
            )
            ,
            const SizedBox(height: 10),
      
            //Button Submit
            ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                          http.Response response =
                        await serviceController.addServcieModel(
                            serviceNameController.text,
                            double.parse(priceController.text),
                            int.parse(timespendController.text));
      
                    if (response.statusCode == 500) {
                      print("Error!");
                    } else {
                      print(serviceNameController.text);
                      print(priceController.text);
                      print(timespendController.text);
                      print("Service was added successfully");
                      if (context.mounted) {                       
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MyApp())); 
                      }
                    }
                    print('success');
                  }               
                },
                child: Text("Add"))
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

  Padding textFieldPrice() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
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
