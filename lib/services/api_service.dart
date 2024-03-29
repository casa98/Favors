import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final baseUrl = 'https://flutter-favors.herokuapp.com/api';
  final headers = {'Content-Type': 'application/json'};

  Future<void> uploadDeviceToken(
      {required String uid, required String deviceToken}) async {
    http.post(
      Uri.parse('$baseUrl/saveDeviceToken'),
      headers: headers,
      body: jsonEncode({
        'uid': uid,
        'deviceToken': deviceToken,
      }),
    );
  }

  Future<void> removeDeviceToken({required String uid}) async {
    http.post(
      Uri.parse('$baseUrl/removeDeviceToken'),
      headers: headers,
      body: jsonEncode({'uid': uid}),
    );
  }

  Future<void> sendNotification({
    required String to,
    required String title,
    required String body,
  }) async {
    http.post(
      Uri.parse('$baseUrl/sendNotification'),
      headers: headers,
      body: jsonEncode({
        'to': to,
        'title': title,
        'body': body,
      }),
    );
  }
}
