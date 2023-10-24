import 'package:miniproject/model/reserve.dart';


class ReserveDetail {
  String? reserveDetailId;
  double? sumPrice;
  DateTime? scheduleDate;
  int? sumTimespend;
  Reserve? reserve;
  String? serviceId;

  ReserveDetail.addReserveDetail({this.reserveDetailId,this.sumPrice,this.scheduleDate});
  
}