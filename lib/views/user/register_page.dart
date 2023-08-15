import 'package:flutter/material.dart';
import 'package:miniproject/components/myButton.dart';
import 'package:miniproject/components/myTextField.dart';

import '../../components/mySeparator.dart';


class registerPage extends StatelessWidget {
  registerPage({super.key});

 final firstnameController = TextEditingController();
 final lastnameController = TextEditingController();
 final emailController = TextEditingController();
 final phonenumberController = TextEditingController();
 final usernameController = TextEditingController();
 final ConfirmpasswordController = TextEditingController();
 final passwordController = TextEditingController();
 final addressController = TextEditingController();

  void Register() {
  
}

 @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
children: [

            const SizedBox(height: 25),
            //Header
            const Text('ลงทะเบียน',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 30)
            ),

const SizedBox(height: 25),
              //FirstName
              MyTextField(
                controller: firstnameController,
                hintText: 'ชื่อจริง',
                obcureText: false,
              ),

              const SizedBox(height: 25),

              //lastname
              MyTextField(
                controller: lastnameController,
                hintText: 'นามสกุล',
                obcureText: false,
              ),

              const SizedBox(height: 25),

              //email
              MyTextField(
                controller: emailController,
                hintText: 'อีเมล์',
                obcureText: false,
              ),
            
              const SizedBox(height: 25),

              //phonenumber
              MyTextField(
                controller: phonenumberController,
                hintText: 'เบอร์โทร',
                obcureText: false,
              ),

              const SizedBox(height: 25),

              //address
              MyTextField(
                controller: addressController,
                hintText: 'ที่อยู่',
                obcureText: false,
              ),
              const SizedBox(height: 15),

       const mySeparator(),

                //username
                const SizedBox(height: 15),
                MyTextField(
                controller: usernameController,
                hintText: 'ชื่อผู้งาน',
                obcureText: false,
              ),

              const SizedBox(height: 25),

              //password
               MyTextField(
                controller: passwordController,
                hintText: 'รหัสผ่าน',
                obcureText: false,
              ),

              const SizedBox(height: 25),

              //confirmpassword
               MyTextField(
                controller: ConfirmpasswordController,
                hintText: 'ยืนยันรหัสผ่าน',
                obcureText: false,
              ),

             const SizedBox(height: 25),

            //Confirm Button
            ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: (){}, child: const Text('ยืนยัน')),

            const SizedBox(height: 25)

            ],
            
          ),         
        ),      
      ),
    );
  }
}