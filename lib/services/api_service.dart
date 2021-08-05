import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<void> uploadDeviceToken(
      {required String uid, required String deviceToken}) async {
    final baseUrl = 'http://10.0.2.2:3000/api';
    http.post(
      Uri.parse('$baseUrl/saveDeviceToken'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'uid': uid,
        'deviceToken': deviceToken,
      }),
    );
  }
}
