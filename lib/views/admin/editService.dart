import 'package:flutter/material.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/main.dart';
import 'package:miniproject/model/service.dart';
import 'package:miniproject/views/user/listService.dart';
import 'package:quickalert/quickalert.dart';

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
  bool isServiceNameCorrect = false;
  bool isPriceCorrect = false;
  bool isTimespendCorrect = false;

  final ServiceController serviceController = ServiceController();

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
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.serviceId);
  }

  void showSureToUpdateServiceAlert(ServiceModel uService) {
    QuickAlert.show(
        context: context,
        title: "แก้ไขสำเร็จ",
        text: "แก้ไขข้อมูลการบริการเสร็จสิ้น",
        type: QuickAlertType.warning,
        confirmBtnText: "แก้ไข",
        onConfirmBtnTap: () async {
          http.Response response =
              await serviceController.updateService(uService);
          if (response.statusCode == 200) {
            if (mounted) {
              Navigator.pop(context);
            }
            showUpdateServiceSuccessAlert();
          } else {}
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showUpdateServiceSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "แก้ไขข้อมูลเสร็จสิ้น",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (bui) => const ListServiceScreen())));
  }

  void showFailToDeleteServiceAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อมูลผิดพลาด",
        text: "ไม่สามารถลบข้อมูลบริการได้",
        type: QuickAlertType.error);
  }

  void showSureToDeleteServiceAlert(String serviceId) {
    QuickAlert.show(
        context: context,
        title: "ลบสำเร็จ",
        text: "ลบข้อมูลบริการเสร็จสิ้น",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: () async {
          http.Response response =
              await serviceController.deleteService(serviceId);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showDeleteServiceSuccessAlert();
          } else {
            showFailToDeleteServiceAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showDeleteServiceSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลเสร็จสิ้น",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (bui) => const ListServiceScreen())));
  }

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
        title: const Text('Edit Service'),
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

          //Box ID Service
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
          textFieldTimespend(),
          const SizedBox(height: 10),

          //Button Submit
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //ส่วนปุ่มกดแก้ไข
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
              ),
            ),
          ])
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
