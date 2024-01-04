import 'dart:convert';

import 'package:miniproject/ws_config.dart';
import 'package:http/http.dart' as http;
class RegisterController{

   Future doRegister (String firstName,String lastName,String address,String email,String mobileNo,
                        String username,String password) async {
      Map<String,dynamic> data = {       
        "firstName" : firstName,
        "lastName" : lastName,
        "address" : address,
        "email" : email,
        "mobileNo" : mobileNo,
        "username" : username,
        "password" : password
      };

      
      var url = Uri.parse(baseURL + '/user/add');

      http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data));

      return response;
    }

}