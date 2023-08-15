import 'dart:convert';

import 'package:miniproject/ws_config.dart';
import 'package:http/http.dart' as http;
class RegisterController{

   Future addResgister (String userId,String firstName,String lastName,String address,String email,String mobileNo,
                        String username,String password) async {
      Map<String,dynamic> data = {
        "userId" : userId,
        "firstName" : firstName,
        "lastName" : lastName,
        "address" : address,
        "email" : email,
        "mobileNo" : mobileNo,
        "username" : username,
        "password" : password
      };

      // var jsonData = json.encode(data);
      var url = Uri.parse(baseURL + '/user/add');

      http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data));

      return response;
    }

}