import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miniproject/model/reserveDetail.dart';
import 'package:miniproject/ws_config.dart';
class ReserveDetailController {

   Future addReserveDetail(String? serviceName,String scheduleDate,String scheduleTime) async {
    Map<String, dynamic> data = {
      "serviceName": serviceName,
      "scheduleDate": scheduleDate,
      "time": scheduleTime
    };

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + '/reserveDetail/add');

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    return response;
  }

  Future listReserveDetails(String reserveId) async {
    var url = Uri.parse(baseURL + '/reserveDetail/getbyreserveId/' + reserveId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
    List<ReserveDetail> list =
        jsonResponse.map((e) => ReserveDetail.fromJsonToReserveDetail(e)).toList();
    return list;
  }  
}