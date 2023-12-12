import 'package:flutter/material.dart';

import '../../controller/reserveController.dart';
import '../../model/reserve.dart';

class DailyIncome extends StatefulWidget {
  const DailyIncome({super.key});

  @override
  State<DailyIncome> createState() => _DailyIncomeState();
}

class _DailyIncomeState extends State<DailyIncome> {
  final ReserveController _reserveController = ReserveController();
  bool? isLoaded = false;
  List<Reserve>? _listReserve;

  void _fetchData()async{
    _listReserve = await _reserveController.getDailyIncome();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
                itemCount: _listReserve?.length,                
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        title: Center(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("วันที่ ${_listReserve?[index].reportIncome}"),
                            Text("${_listReserve?[index].price} บาท")
                          ],
                        )
                        ),
                      
                      ),
                    ),
                  );
                }));
  }
}