import 'dart:convert';

import 'package:miniproject/model/barber.dart';

import '../ws_config.dart';
import 'package:http/http.dart' as http;

class BarberController {
  Future addBarber(String userId) async {
    Map<String, dynamic> data = {
      "userId": userId,
    };

    var url = Uri.parse(baseURL + "/barber/add");

    http.Response response =
        await http.post(url, headers: headers, body: json.encode(data));
    return response;
  }

  Future getBarberById(String barberId) async {
    var url = Uri.parse(baseURL + '/barber/getbyid/' + barberId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8body);
    BarberModel barberModel = BarberModel.fromJsonToBarber(jsonResponse);
    return barberModel;
  }

  Future updateBarber(BarberModel barberModel) async {
    Map<String, dynamic> data = barberModel.fromBarberToJson();

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/barber/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }

  Future deleteBarber(String barberId) async {
    var url = Uri.parse(baseURL + "/barber/delete/" + barberId);

    http.Response response = await http.delete(url);

    return response;
  }

  Future deleteAuthorityLoginBarber(String barberId) async {
    var url = Uri.parse(baseURL + "/barber/deleteAuthority/" + barberId);

    http.Response response = await http.delete(url);

    return response;
  }

  Future listAllBarber() async {
    var url = Uri.parse(baseURL + '/barber/list');

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
    List<BarberModel> list =
        jsonResponse.map((e) => BarberModel.fromJsonToBarber(e)).toList();
    return list;
  }
}
