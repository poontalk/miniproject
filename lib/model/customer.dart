import 'package:miniproject/model/user.dart';

class Customer{
  String? customerId;
  String? userId;
  UserModel? userModel;


  Customer({this.customerId,this.userModel});
  Customer.getCustomer2({this.customerId,this.userId});

   factory Customer.fromJsonToCustomer(Map<String, dynamic> json) {
    return Customer(
      customerId: json["customerId"],
      userModel: UserModel.fromJsonToUser(json["customer"])       
    );
  }

     factory Customer.fromJsonToCustomer2(Map<String, dynamic> json) {
    return Customer.getCustomer2(
      customerId: json["customerId"],
      userId: json["userId"]       
    );
  }
}
  
