import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miniproject/model/reserve.dart';
import 'package:miniproject/ws_config.dart';

class ReserveController {

   Future addReserve(
       String reserveDate, String scheduleTime,double price,String? userId) async {
    Map<String, dynamic> data = {      
      "reserveDate": reserveDate,
      "scheduleTime": scheduleTime,
      "price": price,
      "userId": userId
    };

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + '/reserve/add');

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    return response;
  }

  Future listReserves(String customerId) async {
    var url = Uri.parse(baseURL + '/reserve/getbyReserve/' +customerId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
     List<Reserve> list =
        jsonResponse.map((e) => Reserve.fromJsonToReserve(e)).toList(); 
    return list;
  }

   Future getReserveById(String reserveId) async {
    var url = Uri.parse(baseURL + '/reserve/getbyid/' + reserveId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8body);
    Reserve reserve = Reserve.fromJsonToReserve(jsonResponse);
    return reserve;
  }

   Future deleteReserve(String reserveId) async {
    var url = Uri.parse(baseURL + "/reserve/delete/" + reserveId);

    http.Response response = await http.delete(url);

    return response;
  }
}