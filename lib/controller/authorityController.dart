import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:miniproject/ws_config.dart';

class AuthorityLoginController {

   Future generateAuthorityLogin (int authorityId,Long loginId) async {
      Map<String,dynamic> data = {
        "loginId" : loginId,
        "authorityId" : 4,       
      };

      // var jsonData = json.encode(data);
      var url = Uri.parse(baseURL + '/{loginId}/authority/{authorityId}');

      http.Response response = await http.put(
        url,
        headers: headers,
        body: json.encode(data));

      return response;
    }
}