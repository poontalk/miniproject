import 'package:flutter/material.dart';

import '../../controller/reserveController.dart';
import '../../model/reserve.dart';

class WeeklyIncome extends StatefulWidget {
  const WeeklyIncome({super.key});

  @override
  State<WeeklyIncome> createState() => _WeeklyIncomeState();
}

class _WeeklyIncomeState extends State<WeeklyIncome> {
  final ReserveController _reserveController = ReserveController();
  bool? isLoaded = false;
  List<Reserve>? _listReserve;

  void _fetchData()async{
    _listReserve = await _reserveController.getWeeklyIncome();
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
                            Text("${_listReserve?[index].reportIncome}"),
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