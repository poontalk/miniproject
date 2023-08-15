import 'dart:convert';

class ServiceModel {
  String? serviceId;
  String? serviceName;
  double? price;
  int? timespend;

  ServiceModel({
    this.serviceId,
    this.serviceName,
    this.price,
    this.timespend
  });

    Map<String, dynamic> fromServiceToJson() {
    return <String, dynamic>{
      'serviceId': serviceId,
      'serviceName': serviceName,
      'price': price,
      'timespend': timespend
    };
  }

  factory ServiceModel.fromJsonToService(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json["serviceId"],
      serviceName: json["serviceName"],
      price: json["price"],
      timespend: json["timespend"]
    );
  }

  
}