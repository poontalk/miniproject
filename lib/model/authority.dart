import 'dart:ffi';

class AuthorityLogin {
  int? authorityId;
  Long? loginId;

  AuthorityLogin({this.authorityId,this.loginId});

  Map<String,dynamic> fromAuthorityLoginToJson(){
    return<String,dynamic> {      
      'authorityId' : authorityId,
      'loginId' : loginId
    };
  }

   factory AuthorityLogin.fromJsonToAuthorityLogin(Map<String, dynamic> json) {
    return AuthorityLogin(         
      authorityId: json["authorityId"],
      loginId: json["loginId"]
    );
  }
}