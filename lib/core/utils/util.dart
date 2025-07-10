import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

const PREF_EMAIL = "email";
const PREF_PASSWORD = "password";
const utf8Decoder = Utf8Decoder();

bool isNumeric(String str) {
  final numericRegex = RegExp(r'^[0-9]+$');
  return numericRegex.hasMatch(str);
}

String getRandomDouble(double min, double max, int decimalPlaces) {
  final random = Random();
  final scaledValue = min + random.nextDouble() * (max - min);
  return scaledValue.toStringAsFixed(decimalPlaces);
}

String getCurrentDateTime() {
  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final formattedDate = formatter.format(now);
  return formattedDate;
}

DateTime stripTime(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

bool isTenDaysLessThanToday(DateTime givenDate) {
  DateTime today = DateTime.now();
  DateTime tenDaysAgo = today.subtract(const Duration(days: 10));

  return givenDate.isBefore(tenDaysAgo);
}

Map<String, dynamic> utf8JsonDecode(Response resp) {
  final responseBody = utf8Decoder.convert(resp.bodyBytes);
  final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
  return jsonResponse;
}

List<List<T>> splitList<T>(List<T> originalList, int chunkSize) {
  List<List<T>> chunks = [];
  for (var i = 0; i < originalList.length; i += chunkSize) {
    int end = (i + chunkSize < originalList.length)
        ? i + chunkSize
        : originalList.length;
    chunks.add(originalList.sublist(i, end));
  }
  return chunks;
}
