import 'package:flutter/material.dart';
import 'package:miniproject/components/validator.dart';
import 'package:miniproject/controller/userController.dart';
import 'package:miniproject/model/login.dart';

import '../../model/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  LoginModel? loginModel;
  bool? isLoaded = false;
  UserModel? userModel;

  UserController userController = UserController();

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
  bool isUserNameCorrect= false;
  bool isPasswordCorrect = false;

   //ส่วนการใส่ข้อมูล
  void setDataToText() {
    fNameController.text = userModel?.firstName ?? "";
    lNameController.text = userModel?.lastName ?? "";
    phonenumberController.text = userModel?.mobileNo ?? "";
    emailController.text = userModel?.email ?? "";
    addressController.text = userModel?.address ?? "";
    userNameController.text = userModel?.username ?? "";    
  }

  //ส่วนการรับค่าข้อมูล
  void fetchData(String userId) async {
   // userModel = await userController.getUserById(userId);
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
    //fetchData(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
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
              style:ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: (){

            }, 
            child: const Text('แก้ไข')
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

   //Text field Username
  Padding textFieldFirstName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: fNameController,
        onChanged: (val) {
          setState(() {
            isFnameCorrect = validateName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ชื่อ",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isFnameCorrect == false
              ? const Icon(
                  null
                )
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isFnameCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

    //Text field lastname
  Padding textFieldLastName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: lNameController,
        onChanged: (val) {
          setState(() {
            isLnameCorrect = validateName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "นามสกุล",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isLnameCorrect == false
              ? const Icon(
                  null
                )
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isLnameCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

    //Text field PhoneNumber
  Padding textFieldPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: phonenumberController,
        onChanged: (val) {
          setState(() {
            isPhoneNumberCorrect = validateName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "เบอร์โทร",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isPhoneNumberCorrect == false
              ? const Icon(
                  null
                )
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isPhoneNumberCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

    //Text field Email
  Padding textFieldEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: emailController,
        onChanged: (val) {
          setState(() {
            isEmailCorrect = validateName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "อีเมล์",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isEmailCorrect == false
              ? const Icon(
                  null
                )
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isEmailCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

    //Text field Address
  Padding textFieldAddress() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: addressController,
        onChanged: (val) {
          setState(() {
            isAddressCorrect = validateName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ที่อยู่",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isAddressCorrect == false
              ? const Icon(
                  null
                )
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isAddressCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

    //Text field Username
  Padding textFieldUserName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: userNameController,
        onChanged: (val) {
          setState(() {
            isUserNameCorrect = validateName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ชื่อผู้ใช้งาน",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isFnameCorrect == false
              ? const Icon(
                  null
                )
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isFnameCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

    //Text field Password
  Padding textFieldPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: passwordController,
        onChanged: (val) {
          setState(() {
            isPasswordCorrect = validateName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "รหัสผ่าน",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isPasswordCorrect == false
              ? const Icon(
                  null
                )
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isPasswordCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}