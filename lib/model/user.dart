class UserModel{  
  String? userId;
  String? firstName;
  String? lastName;
  String? address;
  String? email;
  String? mobileNo;
  String? username;
  String? password;

  UserModel({    
    this.userId,
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
      'userId' : userId,
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
      userId: json["userId"],
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