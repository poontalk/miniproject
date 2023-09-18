import 'package:flutter/material.dart';

import 'package:miniproject/components/myTextField.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:http/http.dart' as http;

import '../../components/validator.dart';
import 'deleteService.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final ServiceController serviceController = ServiceController();

  TextEditingController serviceIdController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timespendController = TextEditingController();
  bool isServiceNameCorrect = false;
  bool isPriceCorrect = false;
  bool isTimespendCorrect = false;
//ส่วนค่า null ใน textfield
  bool _checknullTextfield() {
    if (serviceNameController.text == "" ||
        priceController.text == "" ||
        timespendController.text == "") {
      return false;
    } else {
      return true;
    }
  }

//ส่วนเช็ค script
  bool _checkValidator() {
    if (isPriceCorrect && isServiceNameCorrect && isTimespendCorrect == false) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: Column(
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
          textFieldTimespend(),
          const SizedBox(height: 10),

          //Button Submit
          ElevatedButton(
              onPressed: () async {
                if (!_checknullTextfield()) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('แจ้งเตือน'),
                          content: const Text('กรุณากรอกข้อมูลทั้งหมด'),
                          actions: <Widget>[
                            // ปุ่มปิด AlertDialog
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                } else if (_checkValidator()) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('แจ้งเตือน'),
                          content: const Text('กรุณากรอกข้อมูลให้ถูกต้อง'),
                          actions: <Widget>[
                            // ปุ่มปิด AlertDialog
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                } else {
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeleteServiceScreen()));
                  }
                  print('success');
                }
              },
              child: Text("Add"))
        ],
      ),
    );
  }

  Padding textFieldServiceName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: serviceNameController,
        onChanged: (val) {
          setState(() {
            isServiceNameCorrect = validateServiceName(val);
          });
        },
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
          suffixIcon: isServiceNameCorrect == false
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:
                      isServiceNameCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Padding textFieldPrice() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: priceController,
        onChanged: (val) {
          setState(() {
            isPriceCorrect = validateServicPrice(val);
          });
        },
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
          suffixIcon: isPriceCorrect == false
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isPriceCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Padding textFieldTimespend() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: timespendController,
        onChanged: (val) {
          setState(() {
            isTimespendCorrect = validateServicTimespend(val);
          });
        },
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
          suffixIcon: isTimespendCorrect == false
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:
                      isTimespendCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
