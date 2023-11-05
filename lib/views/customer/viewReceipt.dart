import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/controller/reserveController.dart';
import 'package:miniproject/controller/reserveDetailController.dart';
import 'package:miniproject/model/reserve.dart';
import 'package:miniproject/model/reserveDetail.dart';

class ViewReceipt extends StatefulWidget {
  final String receiptId;
  const ViewReceipt({super.key,required this.receiptId});

  @override
  State<ViewReceipt> createState() => _ViewReceiptState();
}

class _ViewReceiptState extends State<ViewReceipt> {
  ReserveController _reserveController = ReserveController();
  ReserveDetailController _reserveDetailController = ReserveDetailController();
  Reserve? _reserve;
  bool isLoaded = false;
  List<ReserveDetail>? _reserveDetail;

  void _fetchData(String receiptId) async{
    _reserve = await _reserveController.getReceipt(receiptId);
    String? reserveId = _reserve?.reserveId;
    _reserveDetail = await _reserveDetailController.listReserveDetails(reserveId!);
    setState(() {
      isLoaded = true;
    });

  }

  @override
  void initState() {    
    super.initState();
    _fetchData(widget.receiptId);
  }

  @override
  Widget build(BuildContext context) {
       String formattedPayDate = '';
                    if(_reserve?.receiptId != null){
                    DateTime parsedTime =
                        DateTime.parse("${_reserve?.paydate}");
                    formattedPayDate = DateFormat('dd/MM/yyyy').format(parsedTime);
                    }  
    return  Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดใบเสร็จ"),
      ),
      body: Center(
        child: Column(
            children: [
               SizedBox(height: 25),
              //Header
               Text('ใบเสร็จ',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),

              SizedBox(height: 25),
              Padding(
                
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("เลขที่ใบเสร็จ: ${_reserve?.receiptId}"),
                    Text("วันที่ชำระ: $formattedPayDate")
                ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Container(
                  height: 2.5,
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.black,
                  margin: EdgeInsets.only(bottom: 25.0),
                ),
              ),

              Text("ชื่อช่างตัดผม: ${_reserve?.barberModel?.userModel?.firstName}  ${_reserve?.barberModel?.userModel?.lastName}"),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ชื่อบริการ"),
                    Text("ราคา")
                  ],
                ),
                ),

                  Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Container(
                  height: 2.5,
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.black,
                  margin: EdgeInsets.only(top: 5.0),
                ),
              ),

                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: _reserveDetail?.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${_reserveDetail?[index].service?.serviceName}"),
                            Text("${_reserveDetail?[index].service?.price}"),
                          ],
                        ),
                        );
                    }
                  )
                )
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("ยอดรวมทั้งหมด: ${_reserve?.price} บาท"),
                  ],
                ),
              ),

                Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Container(
                  height: 2.5,
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.black,
                  margin: EdgeInsets.only(top: 5.0),
                ),
              ),
            ],
          ),
      ),);
  }
}