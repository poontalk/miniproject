import 'package:flutter/material.dart';
import 'package:miniproject/model/service.dart';

import '../../components/validator.dart';
import '../../controller/service_controller.dart';

final reserveDateController = TextEditingController();
final scheduleTimeController = TextEditingController();

class ReserveSerivePage extends StatefulWidget {
  ReserveSerivePage({super.key});

  @override
  State<ReserveSerivePage> createState() => _ReserveSerivePageState();
}

class _ReserveSerivePageState extends State<ReserveSerivePage> {
  final ServiceController serviceController = ServiceController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController reserveDateController = TextEditingController();
  TextEditingController reserveTimeController = TextEditingController();
  
  bool isDateCorrect = false;
  bool isTimeCorrect = false;
  bool isLoaded = false;
  List<ServiceModel>? serviceModels;
  var selectedValue;


  void fetchData() async {
    serviceModels = await serviceController.listAllService();
    if(mounted){
      setState(() {
      isLoaded = true;
    });
    }    
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
              const SizedBox(height: 25),
              //Header
              const Text('จองคิว',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),
        
              //วันที่จอง
              const SizedBox(height: 35),
              textFieldReserveDate(),
        
              //เวลาที่จอง
              const SizedBox(height: 35),
              textFieldReserveTime(),
        
              //บริการ
              const SizedBox(height: 35),
              //ส่วนชื่อหัวข้อ บริการ
             const Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 25.0),
                  child: Text('บริการ',style: TextStyle(fontSize: 20),),
                )
              ],            
              ),
              const SizedBox(height: 15),
              //ส่วนชื่อหัวข้อ รายการบริการ
              Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 30.0),
                  child: dropdownService(),
                )
              ],            
              ),
              
              //ปุ่มกดเพิ่ม
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow,
                      side: const BorderSide(color: Colors.black,width: 2)),      
                      onPressed: (){
                  
                    }, child:const Text('เพิ่ม')),
                  )
                ],
              ),
              const SizedBox(height: 20,),
        
              Container(     
                //alignment: ,                      
                 decoration: BoxDecoration(
                 border: Border.all(),
                ),
                height: MediaQuery.of(context).size.height*0.3,
                width:  MediaQuery.of(context).size.width*1,
                child: const Text('รายการจอง'),
               )
            ],
                    
          ),
        ),
      ),
    );
  }
  
  //DropdownService
  FutureBuilder<List<ServiceModel>> dropdownService() {
    return FutureBuilder<List<ServiceModel>>(
            future: serviceController.getService(),
            builder: (context,snapshot){
                if(snapshot.hasData){
                  return DropdownButton(
                    borderRadius: BorderRadius.circular(10),
                    hint: Text('กรุณาเลือกบริการ'),
                    value: selectedValue,
                    items: snapshot.data!.map((e){
                      return DropdownMenuItem(
                        value: e.serviceName,
                        child: Text(
                            e.serviceName.toString()
                        )
                        );
                    }).toList(),
                    onChanged: (value) {
                      if(mounted){
                          setState(() {
                        selectedValue = value;
                      });
                      }                      
                    });
                }else if (snapshot.hasError){
                  return Text("Error: ${snapshot.error}");
                }else{
                  return const CircularProgressIndicator();
                }
            }
            );
  }

  //Text field Reserve Date
  Padding textFieldReserveDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: reserveDateController,        
        showCursor: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "วันที่จอง",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15), border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  //Text field Reserve Time
  Padding textFieldReserveTime() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: reserveTimeController,        
        showCursor: true,
       style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "เวลาจอง",
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15), border: const OutlineInputBorder(
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
