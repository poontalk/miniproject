import 'dart:ffi';

class AuthorityModel {
  int? authorityId;
  Long? loginId;
  String? role;

  AuthorityModel({this.authorityId,this.role});

  Map<String,dynamic> fromAuthorityToJson(){
    return<String,dynamic> {      
      'authorityId' : authorityId,      
      'role' : role
    };
  }

   factory AuthorityModel.fromJsonToAuthority(Map<String, dynamic> json) {
    return AuthorityModel(         
      authorityId: json["authorityId"],     
      role: json["role"]
    );
  }
}