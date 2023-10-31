import 'dart:convert';

import 'package:miniproject/model/customer.dart';
import 'package:miniproject/ws_config.dart';
import 'package:http/http.dart' as http;

class CustomerController {

  Future findCustomerIdByuserId(String userId) async{
     var url = Uri.parse(baseURL + '/customer/getbyuserid/' + userId); 
     http.Response response = await http.get(url);
     final utf8body = utf8.decode(response.bodyBytes);
     var  jsonResponse = json.decode(utf8body);        
    Customer customer = Customer.fromJsonToCustomer2(jsonResponse);
    return customer;
  }
}