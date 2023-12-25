import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/controller/reserveController.dart';
import 'package:miniproject/controller/reserveDetailController.dart';
import 'package:miniproject/model/reserve.dart';
import 'package:miniproject/model/reserveDetail.dart';
import 'package:http/http.dart' as http;

class CancelServicePage extends StatefulWidget {
  const CancelServicePage({super.key});

  @override
  State<CancelServicePage> createState() => _CancelServicePageState();
}

class _CancelServicePageState extends State<CancelServicePage> {
  final ReserveController _reserveController = ReserveController();
  final ReserveDetailController _reserveDetailController =
      ReserveDetailController();

  List<Reserve>? _listReserve;
  DateTime? pickedDate;
  double heightScore = 0.0;
  bool isLoaded = false;
  String? scheduleDate;
  String? reserveId;
  String? userId;

  void fetchData() async {
    userId = await SessionManager().get("userId");
    _listReserve = await _reserveController.listReserves(userId!);
    for (var item in _listReserve!) {
      reserveId = item.reserveId;
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _showSureToDeleteReserveAlert(String? reserveId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('ยกเลิกการจอง'),
              content: Text('ท่านต้องการยกเลิกการจองหรือไม่'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'ไม่'),
                  child: const Text('ไม่'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ใช่');
                    _checkDeleteReserve(reserveId!);
                  },
                  child: const Text('ใช่'),
                ),
              ],
            ));
  }

  void _checkDeleteReserve(String reserveId) async {
    http.Response response = await _reserveController.cancelReserve(reserveId);
    if (response.statusCode == 200) {
      _showDeleteReserveSuccessAlert();
    }
  }

  //ส่วน method การลบสำเร็จ
  void _showDeleteReserveSuccessAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('สำเร็จ'),
              content: Text('ยกเลิกการบริการเสร็จสิ้น'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ตกลง');
                    setState(() {
                      fetchData();
                    });
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ));
  }

  void _showFailCancelReserve() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('แจ้งแตือน'),
              content: Text('สามารถยกเลิกเวลานัดก่อน 1 ชั่วโมงเท่านั้น!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ตกลง');
                    setState(() {
                      fetchData();
                    });
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 25),
            //Header
            const Text('การจอง',
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: 30)),

            Expanded(
                child: ListView.builder(
                    itemCount: _listReserve?.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: _reserveDetailController.listReserveDetails(
                              "${_listReserve?[index].reserveId ?? ''}"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(); // แสดงการโหลด
                            }
                            if (snapshot.hasData) {
                              return _boxCancelReserve(
                                  context, _listReserve![index],
                                  listreserveDetails: snapshot.data);
                            }
                            // ถ้าไม่มีข้อมูล
                            return Text(
                                'ไม่มีข้อมูล'); // หรือแสดงข้อความว่าไม่มีข้อมูล
                          });
                    }))
          ],
        ),
      ),
    );
  }

  Container _boxCancelReserve(BuildContext context, Reserve reserve,
      {required List<ReserveDetail> listreserveDetails}) {
    heightScore = 70.0 * listreserveDetails.length;
    DateTime? reserveDate = reserve.scheduleDate;
    String formattedDate = DateFormat('dd-MM-yyyy').format(reserveDate!);
    return Container(   
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10) ,
      decoration:  BoxDecoration(  
        border: Border.all(),     
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        color: Colors.white, 
      ),          
      child: Column(
        children: [           
          //หัวรายการ และ วันนัด
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 1,
              margin: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("รายการ", style: TextStyle(fontSize: 20)),
                  Text("วันที่  ${formattedDate}",
                      style: TextStyle(fontSize: 20))
                ],
              )),
          const SizedBox(height: 1),
          //เนื้อหาบริการ ช่าง ราคา
          Container(
            height: heightScore,
            width: MediaQuery.of(context).size.width * 1,
            padding: const EdgeInsets.only(left: 25.0),         
            child: ListView.builder(
                itemCount: listreserveDetails.length,
                itemBuilder: ((context, index) {
                  String formattedTime = '';
                  if (listreserveDetails[index].scheduleTime != null) {
                    pickedDate = listreserveDetails[index].scheduleTime;
                    try {
                      DateTime parsedTime = DateTime.parse(
                          "${listreserveDetails[index].scheduleTime!}");
                      formattedTime = DateFormat('HH:mm').format(parsedTime);
                    } catch (e) {
                      formattedTime = 'เวลาไม่ถูกต้อง';
                    }
                  } else {
                    formattedTime = 'ไม่มีข้อมูล';
                  }
                  return ListTile(
                    title: Text(
                        "${listreserveDetails[index].service?.serviceName}   "
                        "${listreserveDetails[index].service?.price}   บาท    "
                        "เวลา ${formattedTime}"),
                  );
                })),
          ),
          Text(
              " ช่างตัดผม:  ${reserve.barberModel?.userModel?.firstName ?? "ไม่มี"} ${reserve.barberModel?.userModel?.lastName ?? ''} "),

          Text(" ราคารวม:  ${reserve.price}"),

          //ปุ่มยกเลิก
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 1,
              margin: const EdgeInsets.only(bottom: 10.0 ,top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          DateTime? scheduleTime;
                          for (var item in listreserveDetails) {
                            scheduleTime = item.scheduleTime;
                          }
                          if (isCheckTimeCancel(scheduleTime!)) {
                            _showSureToDeleteReserveAlert(reserve.reserveId);
                          } else {
                            _showFailCancelReserve();
                          }
                        },
                        child: const Text(
                          'ยกเลิกการจอง',
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                ],
              )), 
        ],
      ),
    );
  }

  bool isCheckTimeCancel(DateTime scheduleTime) {
    try {
      DateTime parsedTime = scheduleTime;
      DateTime currentTime = DateTime.now();
      Duration difference = parsedTime.difference(currentTime);
      // Check if the scheduled time is more than 1 hour before the current time
      return difference.inHours >= 1;
    } catch (e) {
      // Handle parsing error
      return false;
    }
  }
}
