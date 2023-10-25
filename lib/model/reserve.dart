import 'package:flutter/material.dart';
import 'package:miniproject/model/barber.dart';


class Reserve {
  String? reserveId;  
  DateTime? reserveDate;
  DateTime? scheduleDate;
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
  
  Reserve.getReserve({this.reserveId,this.scheduleDate,this.barberModel,this.price});

  Map<String,dynamic> fromReserveToJson(){
    return<String,dynamic> {         
      'reserveDate' : reserveDate,  
      'scheduleTime' : scheduleTime,
      'price' : price      
    };
  }

    factory Reserve.fromJsonToReserve(Map<String, dynamic> json) {
    return Reserve.getReserve(      
      reserveId: json["reserveId"],       
      scheduleDate: DateTime.parse(json["scheduleDate"]) ,
      barberModel: BarberModel.fromJsonToBarber(json["barber"]),
      price: json["totalPrice"]           
    );
  }
}