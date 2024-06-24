import 'package:SomeOne/data/data_sources/api_service.dart';
import 'package:http/http.dart' as http;

Future<void> registerUser(String email, String firstName, String lastName, String password) async {
  const endpoint = 'auth/register'; 
  final data = {
    'email': email,
    'username': {
      'firstName': firstName,
      'lastName': lastName,
    },
    'password': password,
  };

  try {
    final response = await ApiService.postRequest(endpoint, data);

    if (response.statusCode == 200) {
      print('Successfully: ${response.body}');
    } else {
      print('Failed: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to register user');
  }
}
