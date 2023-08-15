import 'package:flutter/material.dart';
import 'package:miniproject/components/myTextField.dart';


final reserveDateController = TextEditingController();
final scheduleTimeController = TextEditingController();

class reserveSerivePage extends StatelessWidget{
    reserveSerivePage({super.key});

    

    @override
    Widget build (BuildContext context){
      return Scaffold(
        body: SingleChildScrollView(
          
            child: Column(
                children: [
                  
                 const SizedBox(height: 25),
            //Header
           const Text('จองคิว',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 30)
            ),

            //วันที่จอง
            const SizedBox(height: 25),
              
      

            const SizedBox(height: 10),
              MyTextField(
                controller: reserveDateController, 
              hintText: 'วันที่จอง',
               obcureText: false),
            
            //เวลาที่จอง
              const SizedBox(height: 25),
              
              MyTextField(
                controller: scheduleTimeController, 
              hintText: 'เวลาที่จอง',
               obcureText: false),
            //บริการ            
            
                
                ],
            
            ),
                    
          ),
      );
    }

}