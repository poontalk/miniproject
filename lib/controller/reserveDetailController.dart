import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miniproject/ws_config.dart';
class ReserveDetailController {

   Future addReserveDetail(String? serviceName,String scheduleDate,) async {
    Map<String, dynamic> data = {
      "serviceName": serviceName,
      "scheduleDate": scheduleDate
    };

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + '/reserveDetail/add');

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    return response;
  }  
}