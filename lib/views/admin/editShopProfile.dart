import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';

import 'package:miniproject/controller/ownerController.dart';
import 'package:miniproject/model/owner.dart';
import 'package:line_icons/line_icons.dart';

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
    setState(() {
      isLoaded = true;
    });
  }

  void _setDataToText() {
    if (owners != null) {
      for (var item in owners!) {      
        shopNameController.text = item.shopName.toString();
        openTimeController.text = DateFormat('HH:mm').format(item.openTime!);
        closeTimeController.text = DateFormat('HH:mm').format(item.closeTime!);
        textDayOffController.text = item.dayOff.toString();
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
                      _selectWeekend();
                     }, icon: Icon(LineIcons.calendar, size: 50)
                     ),
                   const SizedBox(width: 30,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            side: const BorderSide(
                                width: 2, color: Colors.black)),
                        onPressed: () async {},
                        child: const Text('แก้ไข'))
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
                     const SizedBox(width: 30,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            side: const BorderSide(
                                width: 2, color: Colors.black)),
                        onPressed: () async {
                          textDayOffController.clear();
                        },
                        child: const Text('ลบ'))
                  ],
                ),

                const SizedBox(height: 25),

                //Confirm Button
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {

                      }
                    },
                    child: const Text('แก้ไข'))
              ],
            ),
          )),
    );
  }

  //ชื่อร้าน
  Padding textFieldshopName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: shopNameController,
        //validator: validateServiceName,
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
        //validator: validateServiceName,
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
        //validator: validateServiceName,
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
          //validator: validateServiceName,
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
          //validator: validateServiceName,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          showCursor: true,
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

   Future<void> _selectDate() async{
     pickedDayOff = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
      );

      if(pickedDayOff != null  ){
        setState(() {
          textDayOffController.text  = pickedDayOff.toString().split(" ")[0];
        });
      }
  }

  void _selectWeekend(){
    showDialog(
    context: context, 
    builder: (context) => AlertDialog(
        title: Text("เลือกเวลา"),
        content: Column(
          children: [             
             Center(
             child:  GroupButton(              
              buttons: 
               [
                "จ.",
                "อ.",
                "พ.",
                "พฤ.",
                "ศ.",
                "ส.",
                "อา."                
              ],
              maxSelected: 3,
              isRadio: false,
              onSelected: (value, index, isSelected) => print('$value is selected'),
              options: GroupButtonOptions(
                direction: Axis.horizontal,
                borderRadius: BorderRadius.circular(10),
                spacing: 15,               
                mainGroupAlignment: MainGroupAlignment.center,
                crossGroupAlignment: CrossGroupAlignment.center,
                groupRunAlignment: GroupRunAlignment.center
              ),
             ) 
             
             )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // ทำสิ่งที่คุณต้องการเมื่อปุ่ม OK ถูกคลิก
              Navigator.of(context).pop();
            },
            child: Text('ยืนยัน'),
          ),
        ],
      ),
     );
  } 

    Future<void> _selectOpenTime() async{
    pickedOpenTime = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
      );

      if(pickedOpenTime != null){
        setState(() {
          openTimeController.text = pickedOpenTime!.format(context).toString();
        });
      }
  }

     Future<void> _selectCloseTime() async{
    pickedCloseTime = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
      );

      if(pickedCloseTime != null){
        setState(() {
          closeTimeController.text = pickedCloseTime!.format(context).toString();
        });
      }
  }
    
}
