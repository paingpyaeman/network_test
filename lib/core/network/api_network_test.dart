import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class NetworkTestApi {
  static const String _baseUrl = "apis.mytel.com.mm";

  static Future<Response> getNetworkTestAvailability(
      {required String phoneNumber,
      required String accessToken,
      required String operator,
      required String latitude}) async {
    phoneNumber = phoneNumber.substring(1);
    Map<String, dynamic> params = {
      'phoneNo': "+95$phoneNumber",
      'operator': operator,
      'latitude': latitude,
    };

    final response = await http.get(
      Uri.https(
        _baseUrl,
        "/network-test/v3/challenge",
        params,
      ),
      headers: <String, String>{
        'User-Agent': "okhttp/4.9.1",
        'Accept': "application/json",
        'Accept-Encoding': "gzip",
        'content-type': "application/json; charset=utf-8",
        'accept-language': "EN",
        'authorization': "Bearer $accessToken"
      },
    );

    return response;
  }

  static Future<Map<String, dynamic>> submitNetworkTest(
      {required String phoneNumber,
      required String accessToken,
      required String operator,
      required String requestId,
      required double latitude}) async {
    phoneNumber = phoneNumber.substring(1);

    final response = await http.post(
      Uri.https(
        _baseUrl,
        "/network-test/v3/submit",
      ),
      headers: <String, String>{
        'User-Agent': "okhttp/4.9.1",
        'Accept': "application/json",
        'Accept-Encoding': "gzip",
        'accept-language': "EN",
        'authorization': "Bearer $accessToken",
        'content-type': "application/json; charset=UTF-8"
      },
      body: jsonEncode({
        "cellId": _getCellId(),
        "deviceModel": "23076RA4BC",
        "downloadSpeed": _getRandomDouble(5, 45),
        "enb": _getEnb(),
        "latency": _getRandomDouble(40, 80),
        "latitude": latitude,
        "location": "Yangon Region, Myanmar (Burma)",
        "longitude": _getLongitude(),
        "msisdn": "+95$phoneNumber",
        "networkType": "_4G",
        "operator": operator,
        "requestId": requestId,
        "requestTime": _getFormattedDateTime(),
        "rsrp": "-124",
        "township": "Yangon Region",
        "uploadSpeed": _getRandomDouble(4, 40),
      }),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // Helper methods
  static double getLatitude() {
    final random = Random();

    // Generate a random number between 16 and 17
    double randomNumber = 16 + random.nextDouble();

    // Round the number to 7 decimal places
    double roundedNumber = (randomNumber * 1e7).round() / 1e7;

    return roundedNumber;
  }

  static double _getLongitude() {
    final random = Random();

    // Generate a random double between 96 and 97
    double randomNumber = 96 + (random.nextDouble() * (97 - 96));

    // Round the number to 7 decimal places
    double roundedNumber = (randomNumber * 1e7).round() / 1e7;

    return roundedNumber;
  }

  static String _getFormattedDateTime() {
    // Get the current date and time
    DateTime currentTime = DateTime.now();

    // Format the date and time
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(currentTime);

    return formattedDateTime;
  }

  static int _getCellId() {
    return _getRandomInteger(100000, 500000);
  }

  static int _getEnb() {
    return _getRandomInteger(100000, 150000);
  }

  static int _getRandomInteger(int start, int end) {
// Create a random number generator
    final random = Random();

    // Generate a random integer between start and end number
    int randomNumber = start + random.nextInt(end - start + 1);

    return randomNumber;
  }

  /// Get a random double value between [start] and [end] with 1 decimal place.
  static double _getRandomDouble(int start, int end) {
    // Create a random number generator
    final random = Random();

    // Generate a random double between 5 and 45
    double randomNumber = start + (random.nextDouble() * (end - start));

    // Round the number to 1 decimal place
    double roundedNumber = (randomNumber * 10).round() / 10;

    return roundedNumber;
  }
}
