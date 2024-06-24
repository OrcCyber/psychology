import 'dart:convert';
import 'package:SomeOne/utils/constants.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static String createApiUrl(String endpoint) {
    print('URL:$BASE_URL$endpoint');
    return '$BASE_URL$endpoint';
  }

  static Future<http.Response> getRequest(String endpoint) {
    final url = createApiUrl(endpoint);
    return http.get(Uri.parse(url));
  }

  static Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> data) {
    final url = createApiUrl(endpoint);
    return http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
  }

}
