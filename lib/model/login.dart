import 'dart:ffi';

class LoginModel {
  Long? loginId;
  String? username;
  String? password;

  LoginModel({this.loginId,this.username,this.password});

  Map<String,dynamic> fromLoginToJson(){
    return<String,dynamic> {    
      'loginId' : loginId,  
      'username' : username,
      'password' : password
    };
  }

   factory LoginModel.fromJsonToLogin(Map<String, dynamic> json) {
    return LoginModel(         
      loginId: json["loginId"],
      username: json["username"],
      password: json["password"]
    );
  }
}