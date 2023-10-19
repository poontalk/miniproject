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

   Future doProfileDetail(String userId) async {
    var url = Uri.parse(baseURL + '/user/getbyid/' + userId);

    http.Response response = await http.get(url);

    final utf8body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8body);
    UserModel userModel = UserModel.fromJsonToUser(jsonResponse);
    return userModel;
  }

   Future doEditProfile(String userId, String firstname ,String lastname
            , String address ,String email , String tel, String loginId,
            String username,String password) async {
     Map<String, String> data = {  
      "userId": userId,    
      "firstName": firstname,
      "lastName": lastname,
      "address": address,
      "email": email,
      "mobileNo": tel,
      "loginId": loginId,
      "userName": username,
      "password": password
    };

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/user/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }

  Future doEditProfileNoChangePassword(String userId, String firstname ,String lastname
            , String address ,String email , String tel) async {
    Map<String, String> data = {  
      "userId": userId,    
      "firstName": firstname,
      "lastName": lastname,
      "address": address,
      "email": email,
      "mobileNo": tel,
    };

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/user/updateNoPassword');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }
}