import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/controller/reserveController.dart';
import 'package:miniproject/model/reserve.dart';
import 'package:miniproject/views/customer/viewReceipt.dart';

class ListReserveCustomer extends StatefulWidget {
  const ListReserveCustomer({super.key});

  @override
  State<ListReserveCustomer> createState() => _ListReserveCustomerState();
}

class _ListReserveCustomerState extends State<ListReserveCustomer> {
  final ReserveController _reserveController = ReserveController();
  bool? isLoaded = false;
  List<Reserve>? _reserves;
  String? userId;
  double heightScore = 0;

  void fetchData() async {
    userId = await SessionManager().get("userId");
    _reserves = await _reserveController.listReservesForCustomer(userId!);
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
    heightScore = 90.0 * _reserves!.length;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 25),
            //Header
            const Text('ประวัติการจองของฉัน',
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: 30)),

            Expanded(
              child: ListView.builder(
                  itemCount: _reserves?.length,
                  itemBuilder: ((context, index) {
                    String formattedTime = '';
                    if(_reserves?[index].reserveDate != null){
                    DateTime parsedTime =
                        DateTime.parse("${_reserves?[index].reserveDate}");
                    formattedTime = DateFormat('dd/MM/yyyy').format(parsedTime);
                    }                   
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          title:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[                              
                              Text("วันที่ $formattedTime \n" "เลขที่ใบเสร็จ ${_reserves?[index].receiptId}"),
                              Text('\nดูเพิ่มเติม....'),                              
                            ],                            
                          ),
                          onTap: () =>  Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => ViewReceipt(
                                        receiptId:
                                            _reserves?[index].receiptId ??
                                                "",
                                      ))),)
                        
                      ),
                    );
                  })),
            ),
          ],
        ),
      ),
    );
  }
}
