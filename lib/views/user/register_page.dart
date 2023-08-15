import 'package:flutter/material.dart';
import 'package:miniproject/components/myButton.dart';
import 'package:miniproject/components/myTextField.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/controller/registerController.dart';
import 'package:miniproject/views/user/login_page.dart';
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

  final RegisterController rc = RegisterController();

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
                obcureText: true,
              ),

              const SizedBox(height: 25),

              //confirmpassword
               MyTextField(
                controller: ConfirmpasswordController,
                hintText: 'ยืนยันรหัสผ่าน',
                obcureText: true,
              ),

             const SizedBox(height: 25),

            //Confirm Button
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async{
                  http.Response response = await(rc.addResgister(
                  "U0001", firstnameController.text, lastnameController.text, addressController.text, 
                  emailController.text, phonenumberController.text, usernameController.text, ConfirmpasswordController.text)
                  );
                   if (response.statusCode == 500) {
                    print("Error!");
                }  else {
                  // print(firstnameController.text);
                  // print(lastnameController.text);
                  // print(addressController.text);
                  // print(emailController.text);                  
                  print("Service was added successfully");
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (bui) => LoginPage())
                 );
                }   
              }, child: const Text('ยืนยัน')),

            const SizedBox(height: 25)

            ],
            
          ),         
        ),      
      ),
    );
  }
}