import 'package:flutter/material.dart';

class Owner {
  String? ownerId;
  String? shopName;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  DateTime? dayOff;
  DateTime? weekend;

  Owner({this.ownerId,this.shopName,this.openTime,this.closeTime,this.dayOff,this.weekend});
}