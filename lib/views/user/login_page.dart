import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/components/myButton.dart';
import 'package:miniproject/components/myTextField.dart';
import 'package:miniproject/views/user/register_page.dart';

class LoginPage extends StatelessWidget{
   LoginPage({super.key});


// text editing controllers
final usernameController = TextEditingController();
final passwordController = TextEditingController();

// sign user in method
void signUserIn() {
  
}


  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children:  [
             const SizedBox(height: 50),

            //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

             const SizedBox(height: 50),

            //welcome back ,you've been missed!
            Text('Welcome back, you\'ve been missed!',
            style: TextStyle(
               color: Colors.grey[700],
              fontSize: 16
            ),
            ),

             const SizedBox(height: 25),


            //username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obcureText: false,
              ),


              const SizedBox(height: 25),
            //password textfield
             MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obcureText: true,
             ),

            const SizedBox(height: 25),

            //sign in button
              MyButton(
                onTap: signUserIn,                
              ),

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
                color: Colors.blue,
                fontWeight: FontWeight.bold),
            ),
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => registerPage())
            );},
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
}