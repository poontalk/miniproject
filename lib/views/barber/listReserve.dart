import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/controller/reserveController.dart';
import 'package:miniproject/controller/reserveDetailController.dart';
import 'package:miniproject/model/reserve.dart';
import 'package:miniproject/model/reserveDetail.dart';
import 'package:http/http.dart' as http;

class ListReserveBarber extends StatefulWidget {
  const ListReserveBarber({super.key});

  @override
  State<ListReserveBarber> createState() => _ListReserveBarberState();
}

class _ListReserveBarberState extends State<ListReserveBarber> {
  bool? isLoaded = false;
  final ReserveDetailController _reserveDetailController =
      ReserveDetailController();
  final ReserveController _reserveController = ReserveController();
  List<Reserve>? _listReserveBarber;
  String? _name;
  double? _totalPrice;

  String? reserveId;

  void _fetchData() async {
    _listReserveBarber = await _reserveController.listReserveForBarber();
    for (var item in _listReserveBarber!) {
      reserveId = item.reserveId;
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 25),
          const Text('รายการการจอง',
              style: TextStyle(
                  decoration: TextDecoration.underline, fontSize: 30)),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(             
              children: [
                Text("ชื่อลูกค้า",style: TextStyle(fontSize: 15),),
                SizedBox(width: 75,),
                Text(" \t \t \t เวลา",style: TextStyle(fontSize: 15)),
                SizedBox(width: 35,),
                Text("\t \t \t บริการ",style: TextStyle(fontSize: 15))
              ],
            ),
          ),

          //รายละเอียดการจอง
          Expanded(
            child: ListView.builder(
                itemCount: _listReserveBarber?.length,
                itemBuilder: ((context, index) {
                  return FutureBuilder(
                      future: _reserveDetailController.listReserveDetails(
                          _listReserveBarber?[index].reserveId ?? ''),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // แสดงการโหลด
                        }
                        if (snapshot.hasData) {
                          List<ReserveDetail> listReserveDetailsBarber =
                              snapshot.data; // นำข้อมูลมาใส่ใน list
                          _name =
                              "${_listReserveBarber?[index].customer?.firstName} ${_listReserveBarber?[index].customer?.lastName}";
                          _totalPrice = _listReserveBarber?[index].price;
                          return Card(
                            elevation: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${_listReserveBarber?[index].customer?.firstName}"
                                      " ${_listReserveBarber?[index].customer?.lastName}"),
                                  SizedBox(
                                      height: listReserveDetailsBarber.length *
                                          60.0,
                                      width: 180,
                                      child: ListView.builder(
                                          itemCount:
                                              listReserveDetailsBarber.length,
                                          itemBuilder: ((context, index) {
                                            String formattedTime = '';
                                            if (listReserveDetailsBarber[index]
                                                    .scheduleTime !=
                                                null) {
                                              try {
                                                DateTime parsedTime =
                                                    DateTime.parse(
                                                        "${listReserveDetailsBarber[index].scheduleTime}");
                                                formattedTime =
                                                    DateFormat('HH:mm')
                                                        .format(parsedTime);
                                              } catch (e) {
                                                formattedTime =
                                                    'เวลาไม่ถูกต้อง';
                                              }
                                            } else {
                                              formattedTime = 'ไม่มีข้อมูล';
                                            }
                                            return ListTile(
                                              title: Text(
                                                  "${formattedTime}      "
                                                  "      ${listReserveDetailsBarber[index].service?.serviceName}   "),
                                            );
                                          }))),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 2),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              backgroundColor:
                                                  Colors.greenAccent),
                                          onPressed: (() async {
                                            _showConfirmPayment(
                                                _listReserveBarber?[index]
                                                    .reserveId);
                                          }),
                                          child: const Text(
                                            "สำเร็จ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 2),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              backgroundColor:
                                                  Colors.redAccent),
                                          onPressed: (() {
                                            _showCancelJob( _listReserveBarber?[index]
                                                    .reserveId);
                                          }),
                                          child: Text("ยกเลิก"))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        // ถ้าไม่มีข้อมูล
                        return Text('ไม่มีข้อมูล'); //
                      }));
                })),
          )
        ],
      ),
    );
  }

  void _showCancelJob(String? reserveId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('แจ้งเตือน'),
              content: Text(
                  'ท่านต้องการยกเลิกงานหรือไม่'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'ไม่'),
                  child: const Text('ไม่'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ใช่');
                    _checkCancelJob(reserveId);
                  },
                  child: const Text('ใช่'),
                ),
              ],
            ));
  }
  void _checkCancelJob(String? reserveId) async{
     http.Response response = await _reserveController.cancelJob(reserveId);
    if(response.statusCode == 200){
      _showSucessCancel();
    }else{
      _showFailCancel();
    } 
  }

  void _showFailCancel() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('แจ้งเตือน'),
              content: Text('ไม่สามารถยกเลิกงานได้'),
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

  void _showSucessCancel() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('สำเร็จ'),
              content: Text('ยกเลิกงานเสร็จสิ้น'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ตกลง');
                    setState(() {
                      _fetchData();
                    });
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ));
  }

  void _showConfirmPayment(String? reserveId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('ยืนยันการชำระเงิน'),
              content: Text(
                  '$_name ยืนยันการชำระเงินเป็นจำนวนเงิน $_totalPrice บาท'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'ไม่'),
                  child: const Text('ไม่'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ใช่');
                    _checkConfirmPayment(reserveId);
                  },
                  child: const Text('ใช่'),
                ),
              ],
            ));
  }

  Future<void> _checkConfirmPayment(String? reserveId) async {
    http.Response response =
        await _reserveController.doConfimPayment(reserveId);
    if (response.statusCode == 200) {
      _showSucessPayment();
    } else {
      _showFailConfirmPayment();
    }
  }

  void _showSucessPayment() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('สำเร็จ'),
              content: Text('ยืนยันการำระเงินเสร็จสิ้น'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ตกลง');
                    setState(() {
                      _fetchData();
                    });
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ));
  }

  void _showFailConfirmPayment() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('แจ้งเตือน'),
              content: Text('ไม่สามารถยืนยันการชำระเงินได้'),
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
}
