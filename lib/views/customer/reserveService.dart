import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/components/buttonReserve.dart';
import 'package:miniproject/controller/barberController.dart';
import 'package:miniproject/controller/ownerController.dart';
import 'package:miniproject/controller/reserveController.dart';
import 'package:miniproject/model/reserveDetail.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../../controller/customerController.dart';
import '../../controller/reserveDetailController.dart';
import '../../controller/service_controller.dart';
import '../../main.dart';
import '../../model/customer.dart';
import '../../model/owner.dart';
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
  final BarberController barberController = BarberController();
  final ReserveDetailController reserveDetailController =
      ReserveDetailController();
  final OwnerCotroller ownerCotroller = OwnerCotroller();
  CalendarFormat _format = CalendarFormat.month; // รูปแแบบปฎิทิน
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  int? _calOpenTime;
  int? _calCloseTime;
  int? unit; //จำนวน TimeSpend
  int? barberCount;
  bool isLoaded = false;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  bool _serviceSelected = false;
  List<ServiceModel>? serviceModels;
  List<ReserveDetail>? listReserveDetails;
  List<ReserveDetail>? listReserveDetailsUser;
  List<Owner>? owners;
  List<int> showDay = [];
  ServiceModel? _serviceModel;
  Customer? customer;
  var selectedValue;
  String? userId;
  String? _openTime;
  String? _closeTime;
  String? dayOff;

  void fetchData() async {
    serviceModels = await serviceController.getListService();
    listReserveDetails = await reserveDetailController.getCountScheduleTime();
    owners = await ownerCotroller.showShopProfile();
    userId = await SessionManager().get("userId");
    customer = await customerController.findCustomerIdByuserId(userId!);
    listReserveDetailsUser = await reserveDetailController.getScheduleTimeByUserId(userId!);
    _openTime = await SessionManager().get("openTime");
    _closeTime = await SessionManager().get("closeTime");
    barberCount = await barberController.getCountBarber();
    print("จำนวนช่างตัดผมตอนนี้ $barberCount");
    for (var item in owners!) {
      List<String> numbersWeekend = item.weekend.toString().split(",");
      for (int i = 0; i < numbersWeekend.length; i++) {
        int numbersInt = int.parse(numbersWeekend[i]);
        showDay.add(numbersInt);
      }
      if (item.dayOff != null) {
        dayOff = DateFormat("dd-MM-yyyy").format(item.dayOff!);
      }
    }

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
      backgroundColor: Colors.grey[300],
        body: CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.center,
                child: Text('จองบริการ',
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 30)),
              ),
             const SizedBox(height: 10),
              _tableCalendar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
               const Text("รายการบริการ:" ,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                dropdownService(),
                ],
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                child: Center(
                  child: Text(
                    'เลือกเวลาจอง',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
        _isWeekend
            ? SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  alignment: Alignment.center,
                  child: const Text(
                    'วันหยุดไม่สามารถจองได้ , กรุณาเลือกวันอื่น',
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

                        bool isDisable = _checkDisable(timeBooking);

                        return InkWell(
                          splashColor: Colors.black,
                          onTap: () {
                            if (isDisable) {
                              return;
                            }
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
                                    : isDisable
                                        ? Colors.grey
                                        : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: _currentIndex == index
                                  ? Colors.green
                                  : isDisable
                                      ? Colors.grey
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
                                          : isDisable
                                              ? Colors.grey
                                              : null,
                                    ),
                                  )
                                : Text(
                                    '$timeBooking:00 ${timeBooking > 11 ? "PM" : "AM"}', //ข้างหน้าสุดเป็นเวลาเริ่มต้น ส่วนข้างหลังเป็นการปรับเวลาถ้า index > 11 เป็น PM
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _currentIndex == index
                                          ? Colors.white
                                          : isDisable
                                              ? Colors.grey
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
                        '',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ),
        SliverToBoxAdapter(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: ButtonReserve(
                  width: double.infinity,
                  title: 'ยืนยันการจอง',
                  onPressed: () async {
                    int timeBooking = _currentIndex! + _calOpenTime!;
                    http.Response response = await reserveController.addReserve(
                        _currentDay.toString().split(" ")[0],
                        _serviceModel?.price,
                        userId);
                    if (response.statusCode == 200) {
                      http.Response response2 =
                          await reserveDetailController.addReserveDetail(
                              selectedValue.toString(),
                              _currentDay.toString().split(" ")[0],
                              timeBooking.toString());
                      if (response2.statusCode != 200) {
                        _errorInputData(
                            "ไม่สามารถบันทึกคำขอสั่งจองการบริการได้");
                      } else {
                        _successInputData();
                      }
                    } else {
                      _errorInputData("ไม่สามารถบันทึกคำขอสั่งจองการบริการได้");
                    }                    
                  },
                  disable: _dateSelected &&
                          _timeSelected &&
                          _serviceSelected //Check Select date time and service
                      ? false
                      : true)),
        )
      ],
    ));
  }

  //Calendar for Reserve service
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
              color: _dateSelected ? Colors.green : Colors.grey,
              shape: BoxShape.circle)),
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
          // ให้ _isWeekend เป็น true เมื่อ selectedDay.weekday อยู่ใน showDay
          _isWeekend = showDay.contains(selectedDay.weekday);
          if (_isWeekend) {
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }

          String _chooseDay = DateFormat("dd-MM-yyyy")
              .format(selectedDay); // เปลี่ยน datetime to String
          if (_chooseDay == dayOff) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          }
        });
      }),
    );
  }

  //check เวลา open and close shop from database
   bool _checkDisable(int timeBooking) {  
    int timespend = 0; 
    List<int> closeTimes = [];
    String? chooseDay = DateFormat('yyyy-MM-dd').format(_currentDay);
    DateTime currentTime = DateTime.now();
    String? presentDate = DateFormat('yyyy-MM-dd').format(currentTime);
    if (listReserveDetails != null) {
      for (var item in listReserveDetails!) {           
          timespend = item.timespend!;                    
        String? scheduleTime = DateFormat('yyyy-MM-dd').format(item.scheduleTime!);
        if (chooseDay == scheduleTime) {
          if (item.count == barberCount) {
            if (item.count! > 1) {
               closeTimes.add(int.parse(DateFormat('HH').format(item.scheduleTime!)));                
              }
            }
          }             
      }
    }

    if(listReserveDetailsUser != null){
      List<int> scheduleTimeUser = [];
      for(var item in listReserveDetailsUser!){       
        String? scheduleTime = DateFormat('yyyy-MM-dd').format(item.scheduleTime!);
        if(chooseDay == scheduleTime){
          scheduleTimeUser.add(int.parse(DateFormat('HH').format(item.scheduleTime!)));
           timespend = item.timespend!; 
          for (int item in scheduleTimeUser) {
            int endtime = getEndTime(item, timespend); 
            if(timeBooking >= item && timeBooking < endtime){
              print("timeBooking: $timeBooking //// item:$item //// endTime: $endtime");
              return true;
            }
          }
        }
      }
    }

// เช็คว่า timeBooking น้อยกว่า currentTime
    if (chooseDay == presentDate) {
      if (timeBooking <= currentTime.hour) {
        return true;
      }
    }

     // เช็คว่า timeBooking นั้นเกินเวลาปิดหรือไม่
    for (int closeTime in closeTimes) {
      int endtime = getEndTime(closeTime, timespend);      
      // ตรวจสอบว่า timeBooking อยู่ในช่วงเวลาที่มีการจองครบ capacity     
      if (timeBooking >= closeTime && timeBooking < endtime) {
        return true;
      }
    }     
    return false;
  } 

  int getEndTime(int startTime, int timespend) {
  return startTime + timespend;
}




  //คำนวณ เวลาปิด
  void _calculateCloseTime() {
    setState(() {
      unit = _serviceModel!.timespend!;
    });
  }

  void _errorInputData(String details) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('แจ้งเตือน'),
              content: Text(details),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ตกลง');
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ));
  }

  void _successInputData() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('แจ้งเตือน'),
              content: Text('จองบริการช่างตัดผมสำเร็จ!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ตกลง');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ));
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
                  setState(() {
                    _findPriceByServiceName(value);
                    selectedValue = value;
                    _serviceSelected = true;
                  });
                });
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  int _calculateUnitGrid() {
    int calGrid = 0;
    setState(() {
      if (unit != null) {
        calGrid = (_calCloseTime! - _calOpenTime!) ~/ unit!;
      }
    });
    return calGrid;
  }

  Future<void> _findPriceByServiceName(Object? value) async {
    _serviceModel = await serviceController.getServiceByName(value.toString());
    _calculateCloseTime();
  }
}
