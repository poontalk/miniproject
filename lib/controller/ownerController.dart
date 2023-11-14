import 'package:miniproject/model/owner.dart';

import '../ws_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OwnerCotroller{

  Future showShopProfile() async {
    var url = Uri.parse(baseURL + '/owner/list');

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
    List<Owner> list =
        jsonResponse.map((e) => Owner.fromJsonToOwner(e)).toList();
    return list;
  }

  Future addOwner(
       String shopName, String openTime,String closeTime,String dayOff) async {
    Map<String, dynamic> data = {      
      "shopName": shopName,
      "openTime": openTime,
      "closeTime": closeTime,
      "dayOff": dayOff
    };

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + '/owner/add');

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    return response;
  }
}