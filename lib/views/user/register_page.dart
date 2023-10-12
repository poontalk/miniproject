import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/controller/registerController.dart';
import 'package:miniproject/views/user/login_page.dart';
import '../../components/mySeparator.dart';
import '../../components/validator.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final phonenumberController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final RegisterController rc = RegisterController();

  //script ของ confirm password
  String? validateCFpassword(String? password) {
    RegExp passwordRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`@]");
    final ispasswordValid = passwordRegex.hasMatch(password ?? '');
    if (password!.length < 8) {
      return 'รหัสผ่าน อย่างน้อยต้องมี 8 ตัวอักษร';
    }
    if (!ispasswordValid) {
      return 'กรุณากรอกรหัสผ่านใหม่';
    }
    if (password != passwordController.text) {
      return 'รหัสผ่าน ไม่เหมือนกัน';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 25),
              //Header
              const Text('ลงทะเบียน',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),

              const SizedBox(height: 25),
              //FirstName
              _textFieldFirstName(),

              const SizedBox(height: 25),

              //lastname
              _textFieldLastName(),

              const SizedBox(height: 15),

              //email
              _textFieldEmail(),

              const SizedBox(height: 15),

              //phonenumber
              _textFieldPhoneNumber(),

              const SizedBox(height: 25),

              //address
              _textFieldAddress(),

              const SizedBox(height: 15),

              const mySeparator(),
              const SizedBox(height: 15),

              //username
              _textFieldUserName(),

              const SizedBox(height: 25),

              //password
              _textFieldPassword(),

              const SizedBox(height: 25),

              //confirmpassword
              _textFieldConfirmPassword(),

              const SizedBox(height: 25),

              //Confirm Button
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      http.Response response = await (rc.addResgister(
                          firstnameController.text,
                          lastnameController.text,
                          addressController.text,
                          emailController.text,
                          phonenumberController.text,
                          usernameController.text,
                          confirmpasswordController.text));
                      if (response.statusCode == 500) {
                        print("Error!");
                      } else {
                        print("Register was added successfully");
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (bui) => LoginPage()));
                      }
                    }
                  },
                  child: const Text('ยืนยัน')),

              const SizedBox(height: 25)
            ],
          ),
        ),
      ),
    );
  }

  Padding _textFieldConfirmPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: confirmpasswordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'ยืนยันรหัสผ่าน',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: validateCFpassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Padding _textFieldPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'รหัสผ่าน',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: validatePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Padding _textFieldUserName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: usernameController,
        decoration: const InputDecoration(
          hintText: 'ชื่อผู้ใช้งาน',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: validateUserName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Padding _textFieldAddress() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: addressController,
        decoration: const InputDecoration(
          hintText: 'ที่อยู่',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: validateAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Padding _textFieldPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: phonenumberController,
        decoration: const InputDecoration(
          hintText: 'เบอร์โทร',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: validatePhoneNumber,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Padding _textFieldEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
          hintText: 'อีเมล์',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: validateEmail,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Padding _textFieldLastName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: lastnameController,
        decoration: const InputDecoration(
          hintText: 'นามสกุล',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: validateName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Padding _textFieldFirstName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: firstnameController,
        decoration: const InputDecoration(
          hintText: 'ชื่อจริง',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: validateName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
