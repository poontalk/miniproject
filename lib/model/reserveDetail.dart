import 'package:miniproject/model/reserve.dart';
import 'package:miniproject/model/service.dart';


class ReserveDetail {
  String? reserveDetailId;
  double? sumPrice;
  DateTime? scheduleTime;
  int? sumTimespend;
  Reserve? reserve;
  String? serviceId;
  ServiceModel? service;
  

  ReserveDetail.addReserveDetail({this.reserveDetailId,this.sumPrice,this.scheduleTime});
  
  ReserveDetail.getReserveDetail({this.scheduleTime,this.service,this.sumPrice});
  
  factory ReserveDetail.fromJsonToReserveDetail(Map<String, dynamic> json) {    
  return ReserveDetail.getReserveDetail(      
      scheduleTime: DateTime.parse(json["scheduleTime"]),     
      sumPrice: json["sumPrice"],
      service: ServiceModel.fromJsonToService(json["service"])          
    );
  }
}