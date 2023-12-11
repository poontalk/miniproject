import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miniproject/controller/authorityController.dart';
import 'package:miniproject/controller/loginController.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/model/authority.dart';
import 'package:miniproject/model/login.dart';
import 'package:miniproject/model/user.dart';
import 'package:miniproject/views/user/register_page.dart';
import 'package:http/http.dart' as http;

import '../../components/validator.dart';
import '../../controller/userController.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  //import controller
  final UserController userController = UserController();
  final LoginController loginController = LoginController();
  final AuthorityLoginController authorityLoginController =
      AuthorityLoginController();
  final _formKey = GlobalKey<FormState>();
  //import models
  LoginModel? loginModel;
  UserModel? userModel;
  List<AuthorityModel>? authorityModel;

  var sessionManager = SessionManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),

              //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              //welcome back ,you've been missed!
              Text(
                'Welcome back, you\'ve been missed!',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),

              const SizedBox(height: 25),

              //username textfield
              textFieldUserName(),

              const SizedBox(height: 25),
              //password textfield
              textFieldPassword(),

              const SizedBox(height: 25),

              //sign in button
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      http.Response response = await loginController.loginId(
                          usernameController.text, passwordController.text);
                      print(response.body);
                      if (response.body.contains("false")) {
                        // print("Failed Login");
                        Fluttertoast.showToast(msg: "Failed Login");
                      } else {
                        loginModel = await loginController
                            .findLoginIdByUsername(usernameController.text);
                        await _checkRoleUser(context);
                        await _keepUserData();
                        await Future.delayed(const Duration(seconds: 2));
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (bui) => MyApp()));
                        }
                      }
                    }
                  },
                  child: const Text('ยืนยัน')),

              const SizedBox(height: 50),

              //not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?',
                      style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(width: 4),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent                      
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: const Text('Register now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkRoleUser(BuildContext context) async {
    http.Response response2 = await authorityLoginController
        .findAuthorityIdByUsername(usernameController.text);
    var jsonResponse = jsonDecode(response2.body);
    List<dynamic> roles = jsonResponse['authorities'];
    for (int i = 0; i < roles.length; i++) {
      var roleName = roles[i]['role'];
      if (roleName == "barber") {
        await sessionManager.set("roles", roleName);
        print(roleName);
        break;
      } else if (roleName == "admin") {
        await sessionManager.set("roles", roleName);
        print(roleName);
        break;
      }else if(roleName == "owner"){
        await sessionManager.set("roles", roleName);
        print(roleName);
        break;
      }
      await sessionManager.set("roles", "customer");
    }
     
  }

  Future<void> _keepUserData() async {
    userModel =
        await userController.getUserByLoginId(loginModel!.loginId.toString());

    await sessionManager.set("firstname", userModel?.firstName);
    await sessionManager.set("lastname", userModel?.lastName);
    await sessionManager.set("username", loginModel?.username.toString());
    await sessionManager.set("userId", userModel?.userId);
    await sessionManager.set("loginId", loginModel?.loginId);
    print("Success Login");
    print(loginModel?.loginId);
  }

  //Text field Username
  Padding textFieldUserName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: usernameController,
        validator: validateUserName,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: 'ชื่อผู้ใช้งาน',
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          hintText: "somethingUserName",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: Colors.black,
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

  //Text field Password
  Padding textFieldPassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: passwordController,
        validator: validatePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'รหัสผ่าน',
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          prefixIcon: const Icon(
            Icons.key_sharp,
            color: Colors.black,
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
}
