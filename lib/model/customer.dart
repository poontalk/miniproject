class Customer{
  String? customerId;
  String? userId;

  Customer({this.customerId,this.userId});

   factory Customer.fromJsonToCustomer(Map<String, dynamic> json) {
    return Customer(
      customerId: json["customerId"],
      userId: json["userId"]      
    );
  }
}
  
