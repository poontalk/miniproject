class LoginModel {
  String? username;
  String? password;

  LoginModel({this.username,this.password});

  Map<String,dynamic> fromLoginToJson(){
    return<String,dynamic> {      
      'username' : username,
      'password' : password
    };
  }

   factory LoginModel.fromJsonToLogin(Map<String, dynamic> json) {
    return LoginModel(         
      username: json["username"],
      password: json["password"]
    );
  }
}