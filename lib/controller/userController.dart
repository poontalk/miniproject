import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miniproject/model/user.dart';
import 'package:miniproject/ws_config.dart';

class UserController {

    Future listAllUser() async{
    
    var url = Uri.parse(baseURL + '/user/list');

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
    List<UserModel> list = jsonResponse.map((e) => UserModel.fromJsonToUser(e)).toList();
    return list;

  }

  Future listAllBarbers() async{
    
    var url = Uri.parse(baseURL + '/user/listfirstnameandlastname');

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8body);
    List<UserModel> list = jsonResponse.map((e) => UserModel.fromJsonToUser(e)).toList();
    return list;
  }

  Future getUserByLoginId(String loginId) async {
    var url = Uri.parse(baseURL + '/user/getuserbylogin/' + loginId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8body);
    UserModel userModel = UserModel.fromJsonToUser(jsonResponse);
    return userModel;
  }
}