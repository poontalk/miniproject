import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/components/validator.dart';
import 'package:miniproject/controller/customerController.dart';
import 'package:miniproject/controller/reserveController.dart';
import 'package:miniproject/controller/reserveDetailController.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/model/customer.dart';
import 'package:miniproject/model/service.dart';
import '../../controller/service_controller.dart';
import '../../model/reserve.dart';

class ReserveSerivePage extends StatefulWidget {
  ReserveSerivePage({super.key});

  @override
  State<ReserveSerivePage> createState() => _ReserveSerivePageState();
}

class _ReserveSerivePageState extends State<ReserveSerivePage> {
  final ServiceController serviceController = ServiceController();
  final CustomerController customerController = CustomerController();
  final ReserveDetailController reserveDetailController = ReserveDetailController();
  final ReserveController reserveController = ReserveController();
  final _formKey = GlobalKey<FormState>();  
  final TextEditingController _reserveDateController = TextEditingController();
  final TextEditingController _reserveTimeController = TextEditingController();
  DateTime dateTime = DateTime.now();
  
  bool isDateCorrect = false;
  bool isTimeCorrect = false;
  bool isLoaded = false;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;    
  ServiceModel? serviceModel;
  Customer? customer;
  double heightScore = 100.0;
  String? userId;
  List<ServiceModel>? serviceModels;
  var selectedValue;
  Reserve? reserve;
  double totalPrice = 0.0;
  List<Reserve>? listReserves = []; 


  void fetchData() async {
    serviceModels = await serviceController.listAllService();
    userId = await SessionManager().get("userId");   
    customer = await customerController.findCustomerIdByuserId(userId!);
    
    if(mounted){      
      setState(() {
      isLoaded = true;
    });
    }  
    heightScore = 80.0 * listReserves!.length;  
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
                      onPressed: () {    
                        if (_formKey.currentState!.validate()) {                                       
                      Reserve newReserve = Reserve.addReserve(
                        serviceName: selectedValue,                        
                        reserveDate: pickedDate,
                        scheduleTime: pickedTime,
                        price: serviceModel?.price
                      );
                      listReserves?.add(newReserve);  
                      double servicePrice = serviceModel?.price ?? 0.0;
                      for (var item in listReserves!) {                        
                       print(
                        "วันที่: ${item.reserveDate.toString().split(" ")[0]}, "
                              "${item.price} บาท  "
                            "เวลา: ${item.scheduleTime?.format(context).toString()} "
                            "บริการ: ${item.serviceName}"
                            );                                                       
                      }   
                      totalPrice += servicePrice; 
                      print("${totalPrice}");                                        
                       fetchData();
                        }else{
                          _errorInputData("กรุณากรอกข้อมูลทั้งหมด");
                        }
                    }, child:const Text('เพิ่ม')),  
                  )
                ],
              ),
              const SizedBox(height: 20,),
        
              Container(     
                                      
                 decoration: BoxDecoration(
                 border: Border.all(),
                ),
                height: heightScore,
                width:  MediaQuery.of(context).size.width*1,
                child:
                ListView.builder(
                  itemCount: listReserves?.length,
                  itemBuilder: ((context,index){
                      return ListTile(
                        title: Text(
                        "${listReserves?[index].serviceName.toString()}       " 
                        "${listReserves?[index].price}   บาท       "
                        "${listReserves?[index].reserveDate.toString().split(" ")[0]}       "
                        "${listReserves?[index].scheduleTime!.format(context).toString()}"),
                      );
                    }
                   )
                  ),
                 ),

                 const SizedBox(height: 20),

              //Confirm Reserve Service Buttom
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) { 
                        http.Response response = await reserveController.addReserve(                          
                          pickedDate.toString().split(" ")[0],
                          pickedTime!.format(context),
                          totalPrice,
                          userId 
                        );
                        if(response.statusCode == 200){                         
                           for (var item in listReserves!) { 
                            http.Response response2 = await reserveDetailController.addReserveDetail(
                              item.serviceName ,
                              item.reserveDate.toString().split(" ")[0],
                              item.scheduleTime!.format(context).toString()
                               );   
                               if(response2.statusCode != 200){
                                 _errorInputData("ไม่สามารถบันทึกคำขอสั่งจองการบริการได้");
                               }                             
                          }   
                          _successInputData();
                        }else{
                         _errorInputData("ไม่สามารถบันทึกคำขอสั่งจองการบริการได้");
                        }                                         
                                         
                    }
                  },
                  child: const Text('ยืนยัน')),
            ],
                    
          ),
        ),
      ),
    );
  }

  void _errorInputData(String details){
      showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text(details),
          actions:<Widget> [            
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'ตกลง');                 
              } ,
              child: const Text('ตกลง'),
            ),
          ],
        )
        );
  }

  void _successInputData(){
      showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('จองบริการช่างตัดผมสำเร็จ!'),
          actions:<Widget> [            
            TextButton(
              onPressed: () {
                listReserves!.clear();
                _reserveDateController.clear();
                _reserveTimeController.clear();
                selectedValue = "";
                Navigator.pop(context, 'ตกลง'); 
                Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MyApp()));                  
              } ,
              child: const Text('ตกลง'),
            ),
          ],
        )
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
                        _findPriceByServiceName(value);                                               
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

  Future<void> _findPriceByServiceName(Object? value) async {
    serviceModel = await serviceController.getServiceByName(value.toString()); 
  }

  //Text field Reserve Date
  Padding textFieldReserveDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: _reserveDateController, 
        validator: validateReservedate,       
        showCursor: true,
        readOnly: true,
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
        onTap: _selectDate,
      ),
    );
  }

  //Text field Reserve Time
  Padding textFieldReserveTime() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: _reserveTimeController, 
        validator: validateReserveTime,      
        readOnly: true, 
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
        onTap: _selectTime,
      ),
    );
  }

  Future<void> _selectDate() async{
    pickedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
      );

      if(pickedDate != null  ){
        setState(() {
          _reserveDateController.text  = pickedDate.toString().split(" ")[0];
        });
      }
  }

  Future<void> _selectTime() async{
    pickedTime = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
      );

      if(pickedTime != null){
        setState(() {
          _reserveTimeController.text = pickedTime!.format(context).toString();
        });
      }
  }
}
