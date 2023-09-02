import 'dart:convert';

import '../ws_config.dart';
import 'package:http/http.dart' as http;

class BarberController {

    Future addBarber (String userId) async{

       Map<String,dynamic> data = {        
        "userId" : userId,        
      };

    var url = Uri.parse(baseURL + "/barber/add");

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
        );

    return response;

  }
  
    Future deleteBarber (String barberId) async{

    var url = Uri.parse(baseURL + "/barber/delete/" + barberId);

    http.Response response = await http.delete(url);

    return response;

  }
}