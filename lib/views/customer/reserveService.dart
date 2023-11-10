import 'package:flutter/material.dart';
import 'package:miniproject/components/buttonReserve.dart';
import 'package:table_calendar/table_calendar.dart';

class ReserveService extends StatefulWidget {
  const ReserveService({Key? key}) : super(key: key);

  @override
  State<ReserveService> createState() => _ReserveServiceState();
}

class _ReserveServiceState extends State<ReserveService> {  
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  @override 
  void initState() {    
    super.initState();
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
                : SliverGrid(delegate: SliverChildBuilderDelegate(
                (context, index){
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
                      child: Text(
                        '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}', //ข้างหน้าสุดเป็นเวลาเริ่มต้น ส่วนข้างหลังเป็นการปรับเวลาถ้า index > 11 เป็น PM
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _currentIndex == index ? Colors.white : null,
                        ), 
                      ),
                    ),
                  );
                },
                childCount: 8, //จำนวนแถว
                ), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10 ,vertical: 80),
                    child: ButtonReserve(
                      width: double.infinity, 
                      title: 'ยืนยันการจอง', 
                      onPressed: () {}, 
                      disable: _timeSelected && _dateSelected ? false : true
                      )
                  ),
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
      calendarStyle: const CalendarStyle(
          todayDecoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
          //check วันหยุดประจำสัปดาห์
          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      },
    );
  }
}
