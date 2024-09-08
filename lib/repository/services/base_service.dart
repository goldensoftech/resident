import 'dart:io';

import 'package:http/http.dart' as http;

class BaseService {
  BaseService();
  Future<http.Response> post(String url, Map<String, dynamic> conf) async {
    var getUrl = Uri.parse(url);
    return await http.post(getUrl,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: conf['token']
        },
        body: conf);
  }
}
