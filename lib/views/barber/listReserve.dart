import 'package:flutter/material.dart';

class ListReserveBarber extends StatefulWidget {
  const ListReserveBarber({super.key});

  @override
  State<ListReserveBarber> createState() => _ListReserveBarberState();
}

class _ListReserveBarberState extends State<ListReserveBarber> {
  bool? isLoaded = false;
  void _fetchData() async{
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
          Text('มาแล้ว',style: TextStyle(fontSize: 30),)
        ],
      ),
    );
  }
}