// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/controller/ownerController.dart';
import 'package:miniproject/model/owner.dart';
import 'package:line_icons/line_icons.dart';

import '../../components/validator.dart';

class EditShopProfile extends StatefulWidget {
  const EditShopProfile({super.key});
  @override
  State<EditShopProfile> createState() => _EditShopProfileState();
}

class _EditShopProfileState extends State<EditShopProfile> {
  bool isLoaded = false;
  List<Owner>? owners;
  DateTime? pickedDayOff;
  TimeOfDay? pickedOpenTime;
  TimeOfDay? pickedCloseTime;
  List<int> addDay = [];
  List<int> showDay = [];
  int maxSelected = 3;
  List<String> listWeekend = [
    'อาทิตย์',
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์'    
  ];
  List<String> selectedDays = [];
  List<bool> checkedList = List.filled(7, false);
  final OwnerCotroller ownerController = OwnerCotroller();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController openTimeController = TextEditingController();
  TextEditingController closeTimeController = TextEditingController();
  TextEditingController textWeekendController = TextEditingController();
  TextEditingController textDayOffController = TextEditingController();
  var sessionManager = SessionManager();
  final _formKey = GlobalKey<FormState>();
  //ส่วนการรับค่าข้อมูล
  void _fetchData() async {
    owners = await ownerController.showShopProfile();
    _setDataToText();
    await sessionManager.set("openTime", openTimeController.text);
    await sessionManager.set("closeTime", closeTimeController.text);
    List<String> numbers = textWeekendController.text.split(",");
    textWeekendController.clear();
    String formattedDay = "";
    for (int i = 0; i < numbers.length; i++) {
      int numbersInt = int.parse(numbers[i]);
      formattedDay += "${getDays(numbersInt)}";
      showDay.add(numbersInt);
    }    
    textWeekendController.text = formattedDay.substring(0, formattedDay.length - 1);
    
    setState(() {
      isLoaded = true;
    });
  }

  String getDays(day){
    String days;
    const map = {
      0 : "อาทิตย์,",
      1 : "จันทร์,",
      2 : "อังคาร,",
      3 : "พุธ,",
      4 : "พฤหัสบดี,",
      5 : "ศุกร์,",
      6 : "เสาร์,",          
    };
    days = map[day] ?? 'Not found';
    return days;
  }

  void _setDataToText() {
    if (owners != null) {
      for (var item in owners!) {
        shopNameController.text = item.shopName.toString();
        openTimeController.text = DateFormat('HH:mm').format(item.openTime!);
        closeTimeController.text = DateFormat('HH:mm').format(item.closeTime!);
        textDayOffController.text = item.dayOff == null ? "" : DateFormat('dd/MM/yyyy').format(item.dayOff!) ;
        textWeekendController.text = item.weekend.toString();
      }      
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 25),
                //Header
                const Text('แก้ไขโปรไฟล์ร้าน',
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 30)),

                const SizedBox(height: 25),

                textFieldshopName(),

                const SizedBox(height: 25),

                textFieldopenTime(),

                const SizedBox(height: 25),

                textFieldcloseTime(),

                const SizedBox(height: 65),

                Row(
                  children: [
                    textFieldWeekEnd(),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _selectWeekend();
                          });
                        },
                        icon: Icon(LineIcons.calendar, size: 50)),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    textFieldDayOff(),
                    InkWell(
                        onTap: () {
                          _selectDate();
                        },
                        child: const Icon(LineIcons.calendar, size: 50)),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            side: const BorderSide(
                                width: 2, color: Colors.black)),
                        onPressed: isCheckTextDayOff()
                            ? null
                            : () => setState(() {
                                  textDayOffController.clear();
                                }),
                        child: const Text('ลบ'))
                  ],
                ),

                const SizedBox(height: 25),

                //Confirm Button
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green ,foregroundColor: Colors.white),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        http.Response response = await ownerController.editOwner(
                           shopNameController.text, 
                           openTimeController.text, 
                          closeTimeController.text, 
                          textDayOffController.text);
                          if(response.statusCode == 200){
                            print("success edit owner");
                            _fetchData();                            
                          }
                      }else{
                        print("validate ");
                      }
                    },
                    child: const Text('แก้ไข'))
              ],
            ),
          )),
    );
  }

  bool isCheckTextDayOff() {
    if (textDayOffController.text != "") {
      return false;
    } else {
      return true;
    }
  }

  //ชื่อร้าน
  Padding textFieldshopName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: shopNameController,
        validator: validateShopName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ชื่อร้าน",
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

  //เวลาเปิด
  Padding textFieldopenTime() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: openTimeController,
         readOnly: true,
        validator: validateOpenTime,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "เวลาเปิด",
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
        onTap: _selectOpenTime,
      ),
    );
  }

  //เวลาปิด
  Padding textFieldcloseTime() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: closeTimeController,
        readOnly: true,
        validator: validateCloseTime,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "เวลาปิด",
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
        onTap: _selectCloseTime,
      ),
    );
  }

  //วันหยุดประจำสัปดาห์
  Padding textFieldWeekEnd() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: SizedBox(
        width: 155,
        child: TextFormField(
          controller: textWeekendController,
           readOnly: true,
           enabled: false,          
          autovalidateMode: AutovalidateMode.onUserInteraction,
          showCursor: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: "วันหยุดประจำร้าน",
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

  //วันหยุดพิเศษ
  Padding textFieldDayOff() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: SizedBox(
        width: 155,
        child: TextFormField(
          controller: textDayOffController,
           readOnly: true,             
          showCursor: true,
          enabled: false,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: "วันหยุดพิเศษ",
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

  Future<void> _selectDate() async {
    pickedDayOff = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (pickedDayOff != null) {
      setState(() {
        textDayOffController.text = pickedDayOff.toString().split(" ")[0];
      });
    }
  }

  _selectWeekend() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('เลือกวันหยุดประจำสัปดาห์'),
              content: Container(
                height: 380,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: listWeekend.length,
                  itemBuilder: (context, index) {
                    final day = listWeekend[index];
                    return CheckboxListTile(
                      title: Text(day),
                      value: showDay.contains(index),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {                      
                           if (value && showDay.length < maxSelected) {
                              showDay.add(index);
                              selectedDays.add(listWeekend[index]);
                            } else if(!value) {
                              showDay.remove(index);
                              selectedDays.remove(listWeekend[index]);
                            }  
                            // Update checkedList to match showDay
                            checkedList =
                                List.generate(7, (i) => showDay.contains(i));                        
                          }
                        });
                      },                      
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    String position = "";
                    // Do something with checkedList
                    for (var item in showDay) {
                      position += "$item,";
                    }                   
                    http.Response response = await ownerController
                        .addWeekend(position.substring(0, position.length - 1));
                    if (response.statusCode == 200) {
                      print("add weeekend success");
                      _fetchData();
                      Navigator.pop(context, "ยืนยัน");
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectOpenTime() async {
    pickedOpenTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedOpenTime != null) {
      setState(() {
        openTimeController.text = pickedOpenTime!.format(context).toString();
      });
    }
  }

  Future<void> _selectCloseTime() async {
    pickedCloseTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedCloseTime != null) {
      setState(() {
        closeTimeController.text = pickedCloseTime!.format(context).toString();
      });
    }
  }
}
