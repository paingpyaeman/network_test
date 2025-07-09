// lib/core/network/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Uri _buildUri(String path, [Map<String, dynamic>? queryParams]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParams?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Request failed: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      print("Service Get failed");
      throw Exception('Request failed: ${response.statusCode}');
    }
  }
}
