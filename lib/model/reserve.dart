import 'package:flutter/material.dart';
import 'package:miniproject/model/barber.dart';


class Reserve {
  String? reserveId;  
  DateTime? reserveDate;
  TimeOfDay? scheduleTime;
  String? status;
  DateTime? paydate;
  String? receiptId;
  BarberModel? barberModel;
  String? customerId;   
  double? price;
  String? serviceName;
  
  Reserve({this.reserveId,this.reserveDate,this.scheduleTime,this.status,this.paydate,this.receiptId});

  Reserve.addReserve({this.serviceName,this.reserveDate,this.scheduleTime,this.price});

  Map<String,dynamic> fromReserveToJson(){
    return<String,dynamic> {         
      'reserveDate' : reserveDate,  
      'scheduleTime' : scheduleTime,
      'price' : price      
    };
  }
}