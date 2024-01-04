import 'package:flutter/material.dart';
import 'package:miniproject/views/admin/dailyIncome.dart';
import 'package:miniproject/views/admin/monthIncome.dart';
import 'package:miniproject/views/admin/weeklyIncome.dart';

class ReportSummaryIncome extends StatefulWidget {
  const ReportSummaryIncome({super.key});

  @override
  State<ReportSummaryIncome> createState() => _ReportSummaryIncomeState();
}

class _ReportSummaryIncomeState extends State<ReportSummaryIncome>  with TickerProviderStateMixin{
  late final TabController _tabController;  
  bool? isLoaded = false;
  

  void _fetchData() async{    
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this,length: 3);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title:const Text("รายงานผลรวมรายได้"),   
            backgroundColor: Colors.grey[200],         
            bottom: TabBar(
              controller: _tabController,
              tabs: const <Widget>[
                 Tab(text: "วัน"),
                 Tab(text: "สัปดาห์"),
                 Tab(text: "เดือน"),
              ]),),
      backgroundColor: Colors.grey[300],
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          DailyIncome(),
          WeeklyIncome(),
          MonthlyIncome()
        ],
        )
    );
  }
}