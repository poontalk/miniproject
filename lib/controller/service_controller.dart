import 'dart:convert';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:miniproject/model/service.dart';
import 'package:miniproject/ws_config.dart';

class ServiceController {
  Future addServcieModel(
      String serviceName, double price, int timespend) async {
    Map<String, dynamic> data = {
      "serviceName": serviceName,
      "price": price,
      "timespend": timespend
    };

    // var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + '/service/add');

    http.Response response =
        await http.post(url, headers: headers, body: json.encode(data));

    return response;
  }

  Future listAllService() async {
    var url = Uri.parse(baseURL + '/service/list');
    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
    List<ServiceModel> list =
        jsonResponse.map((e) => ServiceModel.fromJsonToService(e)).toList();
    return list;
  }

  Future updateService(ServiceModel serviceModel) async {
    Map<String, dynamic> data = serviceModel.fromServiceToJson();

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/service/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }

  Future deleteService(String serviceId) async {
    var url = Uri.parse(baseURL + "/service/delete/" + serviceId);

    http.Response response = await http.delete(url);

    return response;
  }

  Future getServiceById(String serviceId) async {
    var url = Uri.parse(baseURL + '/service/getbyid/' + serviceId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8body);
    ServiceModel serviceModel = ServiceModel.fromJsonToService(jsonResponse);
    return serviceModel;
  }

  Future<List<ServiceModel>> getService() async {
    try {
      var url = Uri.parse(baseURL + '/service/list');
      http.Response response = await http.get(url);
      final utf8body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(utf8body);
     
      if (response.statusCode == 200) {
        List<ServiceModel> list =
            jsonResponse.map((e) => ServiceModel.fromJsonToService(e)).toList();
        return list;
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception("Fetch Data Error");
  }

  
  Future getServiceByName(String serviceName) async {
    var url = Uri.parse(baseURL + '/service/getbyName/' + serviceName);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8body);
    ServiceModel serviceModel = ServiceModel.fromJsonToService(jsonResponse);
    return serviceModel;
  }
}
