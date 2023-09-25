import 'package:flutter/material.dart';
import 'package:miniproject/components/myTextField.dart';

final shopNameController = TextEditingController();
final openTimeController = TextEditingController();
final closeTimeController = TextEditingController();
final textWeekendController = TextEditingController();
final textDayOffController = TextEditingController();

class EditShopProfile extends StatelessWidget {
  const EditShopProfile({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
           children: [

              const SizedBox(height: 25),
              //Header
             const Text('แก้ไขโปรไฟล์ร้าน',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 30)
              ),

              const SizedBox(height: 25),

              MyTextField(
                controller: shopNameController, 
                hintText: "ชื่อร้าน", 
                obcureText: false),

              const SizedBox(height: 25),

              MyTextField(
                controller: openTimeController, 
                hintText: "เวลาเปิด", 
                obcureText: false),

              const SizedBox(height: 25),

              MyTextField(
                controller: closeTimeController, 
                hintText: "เวลาปิด", 
                obcureText: false),

              const SizedBox(height: 65),

              MyTextField(
                controller: textWeekendController, 
                hintText: 'วันหยุดประจำร้าน', 
                obcureText: false),

 const SizedBox(height: 25),

              MyTextField(
                controller: textWeekendController, 
                hintText: 'วันหยุดประจำร้าน', 
                obcureText: false),
const SizedBox(height: 25),
               //Confirm Button
            ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: (){}, 
              child: const Text('แก้ไข'))



              ],
              ),
        )),
    );
  }
}