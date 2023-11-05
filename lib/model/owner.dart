import 'package:flutter/material.dart';
import 'package:miniproject/model/user.dart';

class Owner {
  String? ownerId;
  String? shopName;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  DateTime? dayOff;
  DateTime? weekend;
  UserModel? userModel;

  Owner({this.ownerId,this.shopName,this.openTime,this.closeTime,this.dayOff,this.weekend,this.userModel});

  Map<String,dynamic> fromBarberToJson(){
    return<String,dynamic> {
      'ownerId' : ownerId,      
      'shopName' : shopName,    
      'openTime': openTime,
      'closeTime': closeTime,
      'dayOff': dayOff,
      'weekend': weekend,
      'user' : userModel?.fromUserToJson()  
    };
  }

   factory Owner.fromJsonToOwner(Map<String, dynamic> json) {
    return Owner(      
      ownerId: json["ownerId"],
      shopName: json["shopName"],  
      openTime: json["openTime"],
      closeTime: json["closeTime"],
      dayOff: json["dayOff"],
      weekend: json["weekend"],
      userModel: UserModel.fromJsonToUser(json["user"])               
    );
  }
}