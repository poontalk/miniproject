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
  int? count;
  int? timespend;
  

  ReserveDetail.addReserveDetail({this.reserveDetailId,this.sumPrice,this.scheduleTime});
  
  ReserveDetail.getReserveDetail({this.scheduleTime,this.service,this.sumPrice});

  ReserveDetail.getReserveDetail2({this.scheduleTime,this.service,this.sumPrice,this.reserve});

  ReserveDetail.getCountReserveDetail({this.scheduleTime,this.count,this.timespend});
  
  factory ReserveDetail.fromJsonToReserveDetail(Map<String, dynamic> json) {    
  return ReserveDetail.getReserveDetail(      
      scheduleTime: DateTime.parse(json["scheduleTime"]),     
      sumPrice: json["sumPrice"],
      service: ServiceModel.fromJsonToService(json["service"])          
    );
  }

   factory ReserveDetail.fromJsonToReserveDetail2(Map<String, dynamic> json) {    
  return ReserveDetail.getReserveDetail2(      
      scheduleTime: DateTime.parse(json["scheduleTime"]),   
      reserve: Reserve.fromJsonToReserve2(json["reserve"]),
      sumPrice: json["sumPrice"],
      service: ServiceModel.fromJsonToService(json["service"])          
    );
  }

    factory ReserveDetail.fromJsonToGetCountScheduleTime(Map<String, dynamic> json) {    
  return ReserveDetail.getCountReserveDetail(      
      scheduleTime: DateTime.parse(json["scheduleTime"]),   
      count: json["count"],  
      timespend: json["timeSpend"]
    );
  }
}