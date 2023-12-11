import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miniproject/model/reserve.dart';
import 'package:miniproject/ws_config.dart';

class ReserveController {

   Future addReserve(
       String scheduleDate,double? price,String? userId) async {
    Map<String, dynamic> data = {      
      "scheduleDate": scheduleDate,      
      "totalPrice": price,
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

  Future listReserveForBarber(String barberId) async{
      var url = Uri.parse(baseURL + '/reserve/listforbarber/$barberId' );

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
     List<Reserve> list =
        jsonResponse.map((e) => Reserve.fromJsonToReserve2(e)).toList(); 
    return list;
  }

  Future listReservesForCustomer(String customerId) async {
    var url = Uri.parse(baseURL + '/reserve/listforcustomer/' +customerId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
     List<Reserve> list =
        jsonResponse.map((e) => Reserve.fromJsonToReserve3(e)).toList(); 
    return list;
  }

   Future getReceipt(String receiptId) async {
    var url = Uri.parse(baseURL + '/reserve/getReceipt/' + receiptId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8body);
    Reserve reserve = Reserve.fromJsonToReserve4(jsonResponse);
    return reserve;
  }

  Future doConfimPayment(String? reserveId) async {
    Map<String, dynamic> data = {
      "reserveId" : reserveId,     
    };

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/reserve/confirmpayment/' + reserveId!);

    http.Response response = await http.patch(url, headers: headers, body: body);

    return response;
  }

    Future cancelJob(String? reserveId) async {
    Map<String, dynamic> data = {
      "reserveId" : reserveId,     
    };

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/reserve/canceljob/' + reserveId!);

    http.Response response = await http.patch(url, headers: headers, body: body);

    return response;
  }

   Future getDailyIncome() async {
     var url = Uri.parse(baseURL + '/reserve/getdailytotal');

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
     List<Reserve> list =
        jsonResponse.map((e) => Reserve.fromJsonToDaily(e)).toList(); 
    return list;
  }

    Future getWeeklyIncome() async {
     var url = Uri.parse(baseURL + '/reserve/getweeklytotal');

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
     List<Reserve> list =
        jsonResponse.map((e) => Reserve.fromJsonToWeekly(e)).toList(); 
    return list;
  }

    Future getMonthlyIncome() async {
     var url = Uri.parse(baseURL + '/reserve/totalMonthlySales');

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
     List<Reserve> list =
        jsonResponse.map((e) => Reserve.fromJsonToMonthly(e)).toList(); 
    return list;
  }
}