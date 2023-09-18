import 'package:flutter/material.dart';
import 'package:miniproject/components/myButton.dart';
import 'package:miniproject/components/myTextField.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/controller/registerController.dart';
import 'package:miniproject/views/user/login_page.dart';
import '../../components/mySeparator.dart';
import '../../components/validator.dart';
import 'package:validators/validators.dart';

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
  bool isEmailCorrect = false;
  bool isFnameCorrect = false;
  bool isLnameCorrect = false;
  bool isAddressCorrect = false;
  bool isPhoneNumberCorrect = false;
  bool isUserNameCorrect = false;
  bool isPasswordCorrect = false;
  bool isCPasswordCorrect = false;

  //เช็คค่าใน textfield
  bool _checkNullTextField() {
    if (passwordController.text == "" ||
        confirmpasswordController.text == "" ||
        firstnameController.text == "" ||
        lastnameController.text == "" ||
        addressController.text == "" ||
        phonenumberController.text == "" ||
        usernameController.text == "" ||
        emailController.text == "") {
      return false;
    } else
      return true;
  }
  //เช็คscript ผิดพลาด
  bool _checkValidator() {
    if (isAddressCorrect &&
        isCPasswordCorrect &&
        isEmailCorrect &&
        isFnameCorrect &&
        isLnameCorrect &&
        isPasswordCorrect &&
        isPhoneNumberCorrect &&
        isUserNameCorrect == false) {
      return true;
    } else {
      return false;
    }
  }

  final RegisterController rc = RegisterController();

  @override
  Widget build(BuildContext context) {
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
                      decoration: TextDecoration.underline, fontSize: 30)),

              const SizedBox(height: 25),
              //FirstName
              textFieldFirstName(),

              const SizedBox(height: 25),

              //lastname
              textFieldLastName(),

              const SizedBox(height: 25),

              //email
              textFieldEmail(),

              const SizedBox(height: 25),

              //phonenumber
              textFieldPhoneNumber(),

              const SizedBox(height: 25),

              //address
              textFieldAddress(),

              const SizedBox(height: 15),

              const mySeparator(),
              const SizedBox(height: 15),

              //username
              textFieldUserName(),

              const SizedBox(height: 25),

              //password
              textFieldPassword(),

              const SizedBox(height: 25),

              //confirmpassword
              textFieldConfirmPassword(),

              const SizedBox(height: 25),

              //Confirm Button
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {                    
                    if (!_checkNullTextField()) {
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
                        print("Service was added successfully");
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

  
  Padding textFieldEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: emailController,
        onChanged: (val) {
          setState(() {
            isEmailCorrect = isEmail(val);
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
          hintText: "something@email.com",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          suffixIcon: isEmailCorrect == false
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
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

  Padding textFieldFirstName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: firstnameController,
        onChanged: (val) {
          setState(() {
            isFnameCorrect = validateName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ชื่อจริง",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isFnameCorrect == false
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
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

  Padding textFieldLastName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: lastnameController,
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
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
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

  Padding textFieldPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: phonenumberController,
        onChanged: (val) {
          setState(() {
            isPhoneNumberCorrect = validatePhoneNumber(val);
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
                      isPhoneNumberCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Padding textFieldAddress() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: addressController,
        onChanged: (val) {
          setState(() {
            isAddressCorrect = validateAddress(val);
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
          hintText: "1/10 จ.เชียงใหม่ ต.สันนาเม็ง อ.สันทราย 50210",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          suffixIcon: isAddressCorrect == false
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
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

  Padding textFieldUserName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: usernameController,
        onChanged: (val) {
          setState(() {
            isUserNameCorrect = validateUserName(val);
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
          suffixIcon: isUserNameCorrect == false
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isUserNameCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Padding textFieldPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        onChanged: (val) {
          setState(() {
            isPasswordCorrect = validatePassword(val);
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
              ? const Icon(null)
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
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

  Padding textFieldConfirmPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: confirmpasswordController,
        obscureText: true,
        onChanged: (val) {
          setState(() {
            if (confirmpasswordController.text == passwordController.text) {
              isCPasswordCorrect = true;
              isCPasswordCorrect = validatePassword(val);
            } else {
              isCPasswordCorrect = false;
            }
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "ยืนยันรหัสผ่าน",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          suffixIcon: isCPasswordCorrect == false
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
                      isCPasswordCorrect == false ? Colors.red : Colors.green,
                  width: 2),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
