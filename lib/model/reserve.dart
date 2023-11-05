import 'package:flutter/material.dart';
import 'package:miniproject/model/barber.dart';
import 'package:miniproject/model/user.dart';


class Reserve {
  String? reserveId;  
  DateTime? reserveDate;
  DateTime? scheduleDate;
  TimeOfDay? scheduleTime;
  String? status;
  DateTime? paydate;
  String? receiptId;
  BarberModel? barberModel;
  UserModel? customer;   
  double? price;
  String? serviceName;
  
  Reserve({this.reserveId,this.reserveDate,this.scheduleTime,this.status,this.paydate,this.receiptId});

  Reserve.addReserve({this.serviceName,this.reserveDate,this.scheduleTime,this.price});
  
  Reserve.getReserve({this.reserveId,this.scheduleDate,this.barberModel,this.price});

  Reserve.getReserve2({this.reserveId,this.customer,this.scheduleDate,this.barberModel,this.price});

  Reserve.getReserve3({this.reserveDate,this.receiptId});

  Reserve.getReserve4({this.reserveDate,this.receiptId,this.reserveId,this.paydate,this.barberModel,this.price});

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
      barberModel: json["barber"] != null ? BarberModel.fromJsonToBarber(json["barber"]) : null,
      price: json["totalPrice"]           
    );
  }

     factory Reserve.fromJsonToReserve2(Map<String, dynamic> json) {
    return Reserve.getReserve2(      
      reserveId: json["reserveId"],  
      customer: UserModel.fromJsonToUser2(json["customer"]),          
      scheduleDate: DateTime.parse(json["scheduleDate"]) ,
      barberModel: json["barber"] != null ? BarberModel.fromJsonToBarber(json["barber"]) : null,
      price: json["totalPrice"]           
    );
  }

      factory Reserve.fromJsonToReserve3(Map<String, dynamic> json) {
    return Reserve.getReserve3(
        reserveDate: DateTime.parse(json["reserveDate"]),
        receiptId: json["receiptId"]
    );
  }

   factory Reserve.fromJsonToReserve4(Map<String, dynamic> json) {
    return Reserve.getReserve4(  
      reserveDate: DateTime.parse(json["reserveDate"]),
      receiptId: json["receiptId"], 
      reserveId: json["reserveId"],         
      paydate: DateTime.parse(json["payDate"]) ,
      barberModel: json["barber"] != null ? BarberModel.fromJsonToBarber(json["barber"]) : null,
      price: json["totalPrice"]               
    );
  }
}