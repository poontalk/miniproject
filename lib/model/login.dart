
class LoginModel {
  int? loginId;
  String? username;
  String? password;
  //List<AuthorityModel>? authorityModel;
  

  LoginModel({this.loginId,this.username,this.password/* ,this.authorityModel */});

  Map<String,dynamic> fromLoginToJson(){
    return<String,dynamic> {    
      'loginId' : loginId,  
      'username' : username,
      'password' : password,
      // 'authorities': authorityModel?.map((authority) => authority.fromAuthorityToJson()).toList(),
    };
  }

   factory LoginModel.fromJsonToLogin(Map<String, dynamic> json) {
   /*  List<dynamic> authoritiesList = json["authorities"];
    List<AuthorityModel> authorityModels = authoritiesList
        .map((authorityJson) => AuthorityModel.fromJsonToAuthority(authorityJson))
        .toList(); */
    return LoginModel(         
      loginId: json["loginId"],
      username: json["username"],
      password: json["password"],      
      // authorityModel: authorityModels
    );
  }
}