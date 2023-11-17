import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:miniproject/components/buttonReserve.dart';
import 'package:miniproject/controller/reserveController.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../../controller/customerController.dart';
import '../../controller/reserveDetailController.dart';
import '../../controller/service_controller.dart';
import '../../main.dart';
import '../../model/customer.dart';
import '../../model/service.dart';

class ReserveService extends StatefulWidget {
  const ReserveService({Key? key}) : super(key: key);

  @override
  State<ReserveService> createState() => _ReserveServiceState();
}

class _ReserveServiceState extends State<ReserveService> {
  final ServiceController serviceController = ServiceController();
  final CustomerController customerController = CustomerController();
  final ReserveController reserveController = ReserveController();
  final ReserveDetailController reserveDetailController = ReserveDetailController();
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool isLoaded = false;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  bool _serviceSelected = false;
  List<ServiceModel>? serviceModels;
  ServiceModel? _serviceModel;
  var selectedValue;
  String? userId;
  Customer? customer;
  String? _openTime;
  String? _closeTime;
  int? _calOpenTime;
  int? _calCloseTime;
  int? unit;

  void fetchData() async {
    serviceModels = await serviceController.listAllService();
    userId = await SessionManager().get("userId");
    customer = await customerController.findCustomerIdByuserId(userId!);
    _openTime = await SessionManager().get("openTime");
    _closeTime = await SessionManager().get("closeTime");
    print(_closeTime!.split(":")[0]);
    print(_openTime!.split(":")[0]);
    if (_openTime != null) {
      _calOpenTime = int.parse(_openTime!.split(":")[0]);
      _calCloseTime = int.parse(_closeTime!.split(":")[0]);
    }

    if (mounted) {
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
        appBar: AppBar(
          title: Text("Reserve Service"),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  _tableCalendar(),
                  dropdownService(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                    child: Center(
                      child: Text(
                        'เลือกเวลาจอง',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
            _isWeekend
                ? SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 30),
                      alignment: Alignment.center,
                      child: const Text(
                        'วันหยุดสุดสัปดาห์ไม่สามารถใช้ได้ , กรุณาเลือกวันอื่น',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  )
                : _serviceSelected
                    ? SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            index = index * unit!;
                           int timeBooking = index + _calOpenTime!;
                           print("timeBooking: $timeBooking");
                            return InkWell(
                              splashColor: Colors.black,
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                  _timeSelected = true;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _currentIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: _currentIndex == index
                                      ? Colors.green
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: index == 0
                                    ? Text(
                                        '${_calOpenTime!}:00 ${index > 11 ? "PM" : "AM"}', //ข้างหน้าสุดเป็นเวลาเริ่มต้น ส่วนข้างหลังเป็นการปรับเวลาถ้า index > 11 เป็น PM
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _currentIndex == index
                                              ? Colors.white
                                              : null,
                                        ),
                                      )
                                    : Text(
                                        '$timeBooking:00 ${timeBooking > 11 ? "PM" : "AM"}', //ข้างหน้าสุดเป็นเวลาเริ่มต้น ส่วนข้างหลังเป็นการปรับเวลาถ้า index > 11 เป็น PM
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _currentIndex == index
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                              ),
                            );
                          },
                          childCount: _calculateUnitGrid(), //จำนวนแถว
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, childAspectRatio: 1.5),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 30),
                          alignment: Alignment.center,
                          child: const Text(
                            'กรุณาเลือกบริการ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ),
            SliverToBoxAdapter(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
                  child: ButtonReserve(
                      width: double.infinity,
                      title: 'ยืนยันการจอง',
                      onPressed: () async{
                        int timeBooking = _currentIndex! + _calOpenTime!;
                         http.Response response = await reserveController.addReserve(
                          _currentDay.toString().split(" ")[0],                         
                          _serviceModel?.price,
                          userId
                        ); 
                        if(response.statusCode == 200){
                          http.Response response2 = await reserveDetailController.addReserveDetail(
                            selectedValue.toString(), 
                            _currentDay.toString().split(" ")[0],
                             timeBooking.toString()
                            ); 
                             if(response2.statusCode != 200){
                                 _errorInputData("ไม่สามารถบันทึกคำขอสั่งจองการบริการได้");
                               }else{
                                _successInputData();
                               }    
                        }else{
                         _errorInputData("ไม่สามารถบันทึกคำขอสั่งจองการบริการได้");
                        }  
                        print("$timeBooking  $_currentDay");
                      },
                      disable:
                          _dateSelected && _timeSelected && _serviceSelected
                              ? false
                              : true)),
            )
          ],
        ));
  }
  
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      calendarStyle:  CalendarStyle(
          todayDecoration:
              BoxDecoration(
                color: _dateSelected ? Colors.green
                                        : Colors.grey, shape: BoxShape.circle)),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
          if(selectedDay.weekday == 3 || selectedDay.weekday == 7){
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          }else{
            _isWeekend = false;
          }
        });
      }),
    );
  }

  void _calculateCloseTime(Object? object) async {
    _serviceModel = await serviceController.getServiceByName(object.toString());
    unit = _serviceModel!.timespend! ~/ 60;
    print("unit: $unit" "  service ${_serviceModel?.serviceName}");
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


  int _calculateUnitGrid() {
    int calGrid = 0;
    if (unit == 0) {
      calGrid = (_calCloseTime! - _calOpenTime!);
      print('calGrid: $calGrid');
      return calGrid;
    } else {
      calGrid = (_calCloseTime! - _calOpenTime!) ~/ unit!;
      print('calGrid: $calGrid');
      return calGrid;
    }
  }

  //DropdownService
  FutureBuilder<List<ServiceModel>> dropdownService() {
    return FutureBuilder<List<ServiceModel>>(
        future: serviceController.getService(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButton(
                borderRadius: BorderRadius.circular(10),
                hint: Text('กรุณาเลือกบริการ'),
                value: selectedValue,
                items: snapshot.data!.map((e) {
                  return DropdownMenuItem(
                      value: e.serviceName,
                      child: Text(e.serviceName.toString()));
                }).toList(),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      selectedValue = value;
                      _serviceSelected = true;
                      _calculateCloseTime(value);
                      _findPriceByServiceName(value);
                    });
                  }
                });
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<void> _findPriceByServiceName(Object? value) async {
    _serviceModel = await serviceController.getServiceByName(value.toString()); 
  }
}
