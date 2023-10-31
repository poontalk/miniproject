import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/controller/reserveController.dart';
import 'package:miniproject/controller/reserveDetailController.dart';
import 'package:miniproject/model/reserve.dart';
import 'package:miniproject/model/reserveDetail.dart';

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
                        child:  Row(                          
                          children: [
                                Text("ชื่อลูกค้า"),
                      Text(" \t \t \t เวลา"),
                      Text("\t \t \t บริการ")
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
                          List<ReserveDetail> listReserveDetailsBarber = snapshot.data; // นำข้อมูลมาใส่ใน list                         
                          return Card(
                            elevation: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${_listReserveBarber?[index].customer?.firstName}"
                                      " ${_listReserveBarber?[index].customer?.lastName}"
                                      ),                                     
                                     SizedBox(
                                         height: listReserveDetailsBarber.length * 60.0,
                                         width: 180,                                      
                                      child: ListView.builder(
                                            itemCount: listReserveDetailsBarber.length,
                                            itemBuilder: ((context, index) {
                                              String formattedTime = '';
                                              if (listReserveDetailsBarber[index].scheduleTime != null) {
                                                try {
                                                  DateTime parsedTime = DateTime.parse(
                                                      "${listReserveDetailsBarber[index].scheduleTime}");
                                                  formattedTime = DateFormat('HH:mm').format(parsedTime);
                                                } catch (e) {
                                                  formattedTime = 'เวลาไม่ถูกต้อง';
                                                }
                                              } else {
                                                formattedTime = 'ไม่มีข้อมูล';
                                              }
                                              return ListTile(
                                                title: Text(
                                                     "${formattedTime}      "
                                                    "      ${listReserveDetailsBarber[index].service?.serviceName}   "                        
                                                   ),
                                              );
                                            }))
                                     ),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.black, width: 2),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                              backgroundColor: Colors.yellow),
                                          onPressed: (() {}),
                                          child: const Text(
                                            "ยืนยันการจอง",
                                            style: TextStyle(color: Colors.black),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.black, width: 2),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                              backgroundColor: Colors.redAccent),
                                          onPressed: (() {}),
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
}
