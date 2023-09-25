import 'dart:convert';


import 'package:miniproject/model/login.dart';
import 'package:miniproject/ws_config.dart';
import 'package:http/http.dart' as http;

class LoginController {

  //ใช้ Log in โดยเรียกผ่าน webservice 
  Future loginId (String userName, String password) async{
      Map<String,dynamic> data = {
        "username" : userName,
        "password" : password        
      };
      var url = Uri.parse(baseURL + '/login/loginUserName');      

      
         http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data));
        print(response.body);
      return response;       
  }  

  Future findLoginIdByUsername(String userName) async{
     var url = Uri.parse(baseURL + '/login/getbyUsername/' + userName); 
     http.Response response = await http.get(url);

     final utf8body = utf8.decode(response.bodyBytes);
     var  jsonResponse = json.decode(utf8body);        
    LoginModel loginModel = LoginModel.fromJsonToLogin(jsonResponse);
    return loginModel;
  }
}