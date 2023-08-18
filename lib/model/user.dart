class UserModel{  
  String? firstName;
  String? lastName;
  String? address;
  String? email;
  String? mobileNo;
  String? username;
  String? password;

  UserModel({    
    this.firstName,
    this.lastName,
    this.address,
    this.email,
    this.mobileNo,
    this.username,
    this.password
  });

  Map<String,dynamic> fromUserToJson(){
    return<String,dynamic> {
      'firstName' : firstName,
      'lastName' : lastName,
      'address' : address,
      'email' : email,      
      'mobileNo' : mobileNo,
      'username' : username,
      'password' : password
    };
  }

   factory UserModel.fromJsonToUser(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["firstName"],
      lastName: json["lastName"],
      address: json["address"],
      email: json["email"],
      mobileNo: json["mobileNo"],    
      username: json["username"],
      password: json["password"]
    );
  }
}