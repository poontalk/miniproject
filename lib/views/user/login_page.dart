import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:miniproject/controller/loginController.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/model/login.dart';
import 'package:miniproject/model/user.dart';
import 'package:miniproject/views/user/dashboard.dart';
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
  //import models
  LoginModel? loginModel;
  UserModel? userModel;
  //property
  bool isUsernameCorrect = false;
  bool isPasswordCorrect = false;
  var sessionManager = SessionManager();

  @override
  Widget build(BuildContext context) {    
    return Scaffold(      
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
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
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    http.Response response = await loginController.loginId(
                        usernameController.text, passwordController.text);

                    if (response.body.contains('false')) {
                      print("Failed Login");
                    } else {
                      loginModel = await loginController
                          .findLoginIdByUsername(usernameController.text);                        
                      userModel = await userController.getUserByLoginId(loginModel!.loginId.toString());
                     
                      await sessionManager.set("firstname", userModel?.firstName);
                      await sessionManager.set("lastname", userModel?.lastName);
                      await sessionManager.set("username", userModel?.username.toString());
                      print("Success Login");
                      print(loginModel?.username);
                      print(userModel?.firstName);
                       if(context.mounted){
                         Navigator.of(context).pushReplacement(
                           MaterialPageRoute(builder: (bui) => MyApp()));
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
                      textStyle: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
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

  //Text field Username
  Padding textFieldUserName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: usernameController,
        onChanged: (val) {
          setState(() {
            isUsernameCorrect = validateUserName(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "Username",
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
          suffixIcon: isUsernameCorrect == false
              ? const Icon(
                  Icons.close_sharp,
                  color: Colors.red,
                )
              : const Icon(Icons.done, color: Colors.green),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isUsernameCorrect == false ? Colors.red : Colors.green,
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
            isPasswordCorrect = validatePassword(val);
          });
        },
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          prefixIcon: const Icon(
            Icons.key_sharp,
            color: Colors.black,
          ),
          suffixIcon: isPasswordCorrect == false
              ? const Icon(
                  Icons.close_sharp,
                  color: Colors.red,
                )
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
}
