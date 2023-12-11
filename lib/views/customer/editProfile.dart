import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:miniproject/components/validator.dart';
import 'package:miniproject/controller/loginController.dart';
import 'package:miniproject/controller/userController.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/model/login.dart';
import 'package:http/http.dart' as http;
import '../../model/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  LoginModel? loginModel;
  bool? isLoaded = false;
  UserModel? userModel;
  var sessionManager = SessionManager();
  UserController userController = UserController();
  LoginController loginController = LoginController();

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isEmailCorrect = false;
  bool isFnameCorrect = false;
  bool isLnameCorrect = false;
  bool isAddressCorrect = false;
  bool isPhoneNumberCorrect = false;
  bool isUserNameCorrect = false;
  bool isPasswordCorrect = false;

  String? userId;
  String? userName;
  int? loginId;

  //ส่วนการใส่ข้อมูล
  void setDataToText() {
    fNameController.text = userModel?.firstName ?? "";
    lNameController.text = userModel?.lastName ?? "";
    phonenumberController.text = userModel?.mobileNo ?? "";
    emailController.text = userModel?.email ?? "";
    addressController.text = userModel?.address ?? "";
    userNameController.text = loginModel?.username ?? "";    
  }

  //ส่วนการรับค่าข้อมูล
  void fetchData() async {
    userId = await SessionManager().get("userId");
    userModel = await userController.doProfileDetail(userId!);
    userName = await SessionManager().get("username");    
    loginModel = await loginController.findLoginIdByUsername(userName!);
     loginId = await SessionManager().get("loginId");
    setDataToText();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Align(
                alignment: Alignment.center,
                child: Text('แก้ไขโปรไฟล์',
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 30)),
              ),

              const SizedBox(height: 20),

              textFieldFirstName(),

              const SizedBox(height: 20),

              textFieldLastName(),

              const SizedBox(height: 20),

              textFieldPhoneNumber(),

              const SizedBox(height: 20),

              textFieldEmail(),

              const SizedBox(height: 20),

              textFieldAddress(),

              const SizedBox(height: 20),

               textFieldUserName(),

               const SizedBox(height: 20),

               textFieldPassword(),

               const SizedBox(height: 20),

              //ปุ่มกดแก้ไข
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green ,foregroundColor: Colors.white),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                        if(passwordController.text.isEmpty){
                          http.Response response = await userController.doEditProfileNoChangePassword(
                            userId!, 
                            fNameController.text,
                            lNameController.text,
                            addressController.text, 
                            emailController.text, 
                            phonenumberController.text);
                        if(response.statusCode == 500){
                          print("failed");
                        }else{   
                          print("success");  
                          if (context.mounted) {                     
                          Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (bui) => MyApp()));
                          }
                        }
                        }else{
                          http.Response response = await userController.doEditProfile(
                            userId!, 
                            fNameController.text,
                            lNameController.text,
                            addressController.text, 
                            emailController.text, 
                            phonenumberController.text,
                            loginId!.toString(),
                            userNameController.text,
                            passwordController.text
                          );
                          if(response.statusCode == 500){
                            print("failed");
                          }
                           print("success");  
                          if (context.mounted) {                     
                          Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (bui) => MyApp()));
                          }
                        }
                    }
                  },
                  child: const Text('แก้ไข')),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  //Text field Username
  Padding textFieldFirstName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: fNameController,
        validator: validateName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ชื่อ",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
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

  //Text field lastname
  Padding textFieldLastName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: lNameController,
        validator: validateName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "นามสกุล",
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  //Text field PhoneNumber
  Padding textFieldPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: phonenumberController,
        validator: validatePhoneNumber,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "เบอร์โทร",
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  //Text field Email
  Padding textFieldEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: emailController,
        validator: validateEmail,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "อีเมล์",
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  //Text field Address
  Padding textFieldAddress() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: addressController,
        validator: validateAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "ที่อยู่",
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  //Text field Username
  Padding textFieldUserName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: userNameController,
        validator: validateUserName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "ชื่อผู้ใช้งาน",
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  //Text field Password
  Padding textFieldPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: passwordController,
        //validator: validatePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "รหัสผ่าน",
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
