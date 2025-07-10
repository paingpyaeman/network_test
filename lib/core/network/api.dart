import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:network_test/core/utils/constants.dart';
import 'package:network_test/core/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> fetchAccountCheck(String phoneNumber) async {
  Map<String, String> params = {"phoneNumber": phoneNumber};

  final response = await http
      .get(
        Uri.https(
          "apis.mytel.com.mm",
          "/myid/authen/v1.0/login/action/check-account",
          params,
        ),
        headers: {"User-Agent": "okhttp/4.9.1"},
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> requestOTP(String phoneNumber) async {
  Map<String, String> params = {"phoneNumber": phoneNumber};

  final response = await http
      .get(
        Uri.https(
          "apis.mytel.com.mm",
          "/myid/authen/v1.0/login/method/otp/get-otp",
          params,
        ),
        headers: {"User-Agent": "okhttp/4.9.1"},
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> getLinkOtherTransactionID(
  String otherNumber,
  String accessToken,
) async {
  final response = await http
      .post(
        Uri.https("apis.mytel.com.mm", "/csm/v1.0/api/individual/subscription"),
        headers: <String, String>{
          "User-Agent": "okhttp/4.9.1",
          "Accept-Encoding": "gzip",
          "authorization": "Bearer $accessToken",
          "Content-Type": "application/json; charset=utf-8",
        },
        body: jsonEncode({"isdn": otherNumber, "subType": "Mobile"}),
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> requestLinkOtherOTP(
  String transactionId,
  String accessToken,
) async {
  final response = await http
      .get(
        Uri.https(
          "apis.mytel.com.mm",
          "/csm/v1.0/api/individual/subscription/$transactionId/verify",
        ),
        headers: <String, String>{
          "User-Agent": "okhttp/4.9.1",
          "Accept-Encoding": "gzip",
          "authorization": "Bearer $accessToken",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> verifyLinkOtherOTP(
  String transactionId,
  String accessToken,
  String otpCode,
) async {
  Map<String, String> params = {"verifyCode": otpCode};

  final response = await http
      .post(
        Uri.https(
          "apis.mytel.com.mm",
          "/csm/v1.0/api/individual/subscription/$transactionId/verify",
          params,
        ),
        headers: <String, String>{
          "User-Agent": "okhttp/4.9.1",
          "Accept-Encoding": "gzip",
          "authorization": "Bearer $accessToken",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

/* DAILY QUEST START */

Future<Map<String, dynamic>> claimDailyQuest(
  String phoneNumber,
  String accessToken,
) async {
  final response = await http
      .post(
        Uri.https(
          "apis.mytel.com.mm",
          "/daily-quest-v3/api/v3/daily-quest/daily-claim",
        ),
        headers: <String, String>{
          'User-Agent': "okhttp/4.9.1",
          'Accept-Encoding': "gzip",
          'authorization': "Bearer $accessToken",
          'accept-language': "en",
          'content-type': "application/json; charset=utf-8",
        },
        body: jsonEncode({"msisdn": "+95${phoneNumber.substring(1)}"}),
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

/* DAILY QUEST END */

// GRAND QUEST
Future<Map<String, dynamic>> getGrandQuestInfo(
  String phoneNumber,
  String accessToken,
) async {
  Map<String, String> params = {
    "clientType": "Android",
    "Platform": "myid",
    "msisdn": "+95${phoneNumber.substring(1)}",
    "revision": "16248",
  };

  final response = await http
      .get(
        Uri.https(
          "apis.mytel.com.mm",
          "daily-quest-v3/api/v3/daily-quest/main-screen",
          params,
        ),
        headers: <String, String>{
          'User-Agent': "okhttp/4.9.1",
          'Accept-Encoding': "gzip",
          "Authorization": "Bearer $accessToken",
          'country_code': "MM",
          'language_code': "en",
          'accept-language': "en",
          'countrycode': "MM",
          'languagecode': "en",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> claimMiniQuest(
  String phoneNumber,
  String accessToken,
  String replaceUrl,
) async {
  final replacedUrl = replaceUrl.replaceAll(
    '{msisdn}',
    "+95${phoneNumber.substring(1)}",
  );
  final fullUrl =
      "$replacedUrl&clientType=Android&Platform=myid&revision=16248";

  final response = await http
      .get(
        Uri.parse(fullUrl),
        headers: <String, String>{
          'User-Agent': "okhttp/4.9.1",
          'Accept-Encoding': "gzip",
          "Authorization": "Bearer $accessToken",
          'country_code': "MM",
          'language_code': "en",
          'accept-language': "en",
          'countrycode': "MM",
          'languagecode': "en",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> claimGrandQuest(
  String phoneNumber,
  String accessToken,
) async {
  final response = await http
      .post(
        Uri.https(
          "apis.mytel.com.mm",
          "/myid/daily-quest/v3.1/api/quest/send-grand-reward",
        ),
        headers: <String, String>{
          "User-Agent":
              "Dalvik/2.1.0 (Linux; U; Android 13; 23076RA4BC Build/TKQ1.221114.001)",
          "Connection": "Keep-Alive",
          "Accept-Encoding": "gzip",
          "session_token": "",
          "Authorization": "Bearer $accessToken",
          "country_code": "MM",
          "language_code": "en",
          "device_id": "1d65413fa6419fa8",
          "user_id": "0",
          "client_type": "1",
          "msisdn": "+95${phoneNumber.substring(1)}",
          "local_code": "95",
          "version": "1.0.95",
          "revision": "222",
          'Content-Type': "application/json; charset=utf-8",
        },
        body: jsonEncode({
          "msisdn": "+95${phoneNumber.substring(1)}",
          "language": "EN",
        }),
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> authenticate(
  String phoneNumber,
  String otpCode,
) async {
  final response = await http.post(
    Uri.https(
      "apis.mytel.com.mm",
      "/myid/authen/v1.0/login/method/otp/validate-otp",
    ),
    headers: <String, String>{
      "User-Agent": "okhttp/4.9.1",
      "Content-Type": "application/json; charset=utf-8",
    },
    body: jsonEncode({
      "appVersion": "1.0.84",
      "buildVersionApp": "194",
      "deviceId": AppStrings.imei,
      "imei": AppStrings.imei,
      "os": AppStrings.os,
      "osApp": AppStrings.os,
      "password": otpCode,
      "phoneNumber": phoneNumber,
      "version": AppStrings.osVersion,
    }),
  );

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> authenticatePassword(
  String phoneNumber,
  String password,
) async {
  final response = await http.post(
    Uri.https("apis.mytel.com.mm", "/myid/authen/v1.0/login/method/password"),
    headers: <String, String>{
      "Host": "apis.mytel.com.mm",
      "User-Agent": "okhttp/4.9.1",
      "Accept-Encoding": "gzip",
      "Content-Type": "application/json; charset=UTF-8",
      "accept-language": "en",
    },
    body: jsonEncode({
      "appVersion": "1.0.84",
      "buildVersionApp": "194",
      "deviceId": AppStrings.imei,
      "imei": AppStrings.imei,
      "os": AppStrings.os,
      "osApp": AppStrings.os,
      "password": password,
      "phoneNumber": phoneNumber,
      "version": AppStrings.osVersion,
    }),
  );

  print("authenticatePassword: ${response.statusCode}");

  return jsonDecode(response.body) as Map<String, dynamic>;
}

// Reset and Login with password START
Future<Map<String, dynamic>> requestOTPForPasswordReset(
  String phoneNumber,
) async {
  Map<String, String> params = {'phoneNumber': phoneNumber};

  final response = await http.get(
    Uri.https(
      "apis.mytel.com.mm",
      "/myid/authen/v1.0/forget-password/request-otp",
      params,
    ),
    headers: {
      'User-Agent': "okhttp/4.9.1",
      'Accept-Encoding': "gzip",
      'accept-language': "en",
    },
  );

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> validatePasswordResetToken(
  String phoneNumber,
  String otpCode,
) async {
  final response = await http.post(
    Uri.https(
      "apis.mytel.com.mm",
      "/myid/authen/v1.0/forget-password/validate-otp",
    ),
    headers: <String, String>{
      'User-Agent': "okhttp/4.9.1",
      'Accept-Encoding': "gzip",
      'accept-language': "en",
      'content-type': "application/json; charset=UTF-8",
    },
    body: jsonEncode({"otp": otpCode, "phoneNumber": phoneNumber}),
  );

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> changePassword(
  String phoneNumber,
  String keyCode,
) async {
  final response = await http
      .post(
        Uri.https(
          "apis.mytel.com.mm",
          "/myid/authen/v1.0/forget-password/change-password",
        ),
        headers: <String, String>{
          'User-Agent': "okhttp/4.9.1",
          'Accept-Encoding': "gzip",
          'accept-language': "en",
          'content-type': "application/json; charset=UTF-8",
        },
        body: jsonEncode({
          "imei": AppStrings.imei,
          "os": AppStrings.os,
          "otp": keyCode,
          "password": AppStrings.resetPassword,
          "phoneNumber": phoneNumber,
          "version": AppStrings.osVersion,
        }),
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}
// Reset and Login with password END

Future<Map<String, dynamic>> getAccountDetails(
  String phoneNumber,
  String accessToken,
) async {
  Map<String, String> params = {"isdn": phoneNumber, "language": "en"};

  final response = await http
      .get(
        Uri.https(
          "apis.mytel.com.mm",
          "/account-detail/api/v1.2/individual/account-main",
          params,
        ),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken",
          "User-Agent":
              "Dalvik/2.1.0 (Linux; U; Android 13; 23076RA4BC Build/TKQ1.221114.001)",
          "client_type": "1",
          "country_code": "MM",
          "device_id": "862798049664317",
          "language_code": "en",
          "local_code": "95",
          "msisdn": "+95${phoneNumber.substring(1)}",
          "revision": "194",
          "session_token": "",
          "user_id": "0",
          "version": "1.0.84",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

// Get package details (exp date, etc)
Future<Map<String, dynamic>> getDataDetails(
  String phoneNumber,
  String accessToken,
  String accountId,
) async {
  Map<String, String> params = {'language': "EN"};

  final response = await http
      .get(
        Uri.https(
          "apis.mytel.com.mm",
          "/account-detail/api/v1.1/individual/$accountId/account-detail",
          params,
        ),
        headers: <String, String>{
          'User-Agent':
              "Dalvik/2.1.0 (Linux; U; Android 13; 23076RA4BC Build/TKQ1.221114.001)",
          'Connection': "Keep-Alive",
          'Accept-Encoding': "gzip",
          'session_token': "",
          'Authorization': "Bearer $accessToken",
          'country_code': "MM",
          'language_code': "en",
          'device_id': AppStrings.imei,
          'user_id': "0",
          'client_type': "1",
          'msisdn': "+95$phoneNumber",
          'local_code': "95",
          'version': "1.0.90",
          'revision': "207",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> getPointDetails(
  String phoneNumber,
  String accessToken,
) async {
  Map<String, String> params = {"phoneNo": phoneNumber};

  final response = await http
      .get(
        Uri.https(
          "apis.mytel.com.mm",
          "/loyalty/v2.0/api/card/inquiry",
          params,
        ),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken",
          "User-Agent":
              "Dalvik/2.1.0 (Linux; U; Android 13; 23076RA4BC Build/TKQ1.221114.001)",
          "client_type": "1",
          "country_code": "MM",
          "device_id": "862798049664317",
          "language_code": "en",
          "local_code": "95",
          "msisdn": "+95${phoneNumber.substring(1)}",
          "revision": "194",
          "session_token": "",
          "user_id": "0",
          "version": "1.0.84",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> getPointDetailsRank(
  String phoneNumber,
  String accessToken,
) async {
  Map<String, String> params = {'phoneNo': "+95${phoneNumber.substring(1)}"};

  final response = await http
      .get(
        Uri.https("apis.mytel.com.mm", "/loyalty/api/v3.1/rank/home", params),
        headers: <String, String>{
          'User-Agent':
              "Dalvik/2.1.0 (Linux; U; Android 13; 23076RA4BC Build/TKQ1.221114.001)",
          'Connection': "Keep-Alive",
          'Accept-Encoding': "gzip",
          'device_id': "1d65413fa6419fa8",
          'client_type': "1",
          'local_code': "95",
          'version': "1.0.90",
          'revision': "207",
          'Authorization': "Bearer $accessToken",
          'session_token': "",
          'language_code': "en",
          'country_code': "MM",
          'user_id': "0",
          'Accept-Language': "EN",
          'msisdn': "+950000000012",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> exchangePoints(
  String phoneNumber,
  String accessToken,
  String rewardCode,
) async {
  final response = await http
      .post(
        Uri.https("apis.mytel.com.mm", "/loyalty/api/v3.1/pack/exchange"),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken",
          "User-Agent": "okhttp/4.9.1",
          "Content-Type": "application/json; charset=utf-8",
        },
        body: jsonEncode({
          "requestId": "862798049664317",
          "requestTime": DateTime.now().millisecondsSinceEpoch.toString(),
          "msisdn": "+95${phoneNumber.substring(1)}",
          "rewardCode": rewardCode,
        }),
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> checkAccount(String phoneNumber) async {
  Map<String, String> params = {"phoneNumber": phoneNumber};

  // check if account exists
  final response = await http
      .get(
        Uri.https(
          "apis.mytel.com.mm",
          "/myid/authen/v1.0/login/action/check-account",
          params,
        ),
        headers: <String, String>{
          "Host": "apis.mytel.com.mm",
          "accept-language": "en",
          "accept-encoding": "gzip",
          "user-agent": "okhttp/4.9.1",
        },
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

// request for registration of myid
Future<Map<String, dynamic>> requestRegistration(String phoneNumber) async {
  final response = await http
      .post(
        Uri.https("apis.mytel.com.mm", "/myid/authen/v1.0/v2/register/request"),
        headers: <String, String>{
          "Host": "apis.mytel.com.mm",
          "User-Agent": "okhttp/4.9.1",
          "Content-Type": "application/json; charset=utf-8",
          "accept-encoding": "gzip",
          "accept-language": "en",
        },
        body: jsonEncode({"msisdn": phoneNumber}),
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

// confirm registration of myid
Future<Map<String, dynamic>> confirmRegistration(
  String phoneNumber,
  String otpCode,
  String reqId,
) async {
  final response = await http
      .post(
        Uri.https("apis.mytel.com.mm", "/myid/authen/v1.0/v2/register/confirm"),
        headers: <String, String>{
          "Host": "apis.mytel.com.mm",
          "User-Agent": "okhttp/4.9.1",
          "Content-Type": "application/json; charset=utf-8",
          "accept-encoding": "gzip",
          "accept-language": "en",
        },
        body: jsonEncode({
          "appVersion": "1.0.70",
          "buildVersionApp": "178",
          "deviceId": "1e43ad9a46fe68af",
          "imei": "1e43ad9a46fe68af",
          "msisdn": phoneNumber,
          "os": "ANDROID Redmi Redmi K30 5G",
          "osApp": "ANDROID",
          "otp": otpCode,
          "reqId": reqId,
          "version": "Redmi",
        }),
      )
      .timeout(const Duration(seconds: 10));

  return jsonDecode(response.body) as Map<String, dynamic>;
}

// get phone number from bar code
Future<Response> getPhoneNumberFromBarCode(String barCode) async {
  final response = await http.post(
    Uri.https("vmyapigw.mytel.com.mm", "/CoreService/UserRouting"),
    headers: <String, String>{
      "Host": "vmyapigw.mytel.com.mm",
      "User-Agent": "okhttp/3.12.1",
      "Content-Type": "application/json; charset=utf-8",
      "accept-encoding": "gzip",
      "Connection": "Keep-Alive",
      "Cache-Control": "no-cache",
      "Authorization":
          "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiUE9TTUdZMDEwMTAwMDMyNVwiLFwiY2hhbm5lbFR5cGVJZFwiOm51bGwsXCJjdXJyZW50RGF0ZVwiOlwiMDkvMTEvMjAyM1wiLFwidXNlcklkXCI6bnVsbCxcIm9iamVjdHR5cGVcIjpudWxsfSIsImlhdCI6MTY5OTU0Mjk2NiwiZXhwIjoxNzAwMTQ3NzY2fQ.A0B2LVrWkj501Q0x922oh4YePtGYnbO2qNMkK6Bi0hbzymhXqyhEG4JPYK50SvY5P1KuhqRDlp7BjbmKgZ02eg",
    },
    body: jsonEncode({
      "sessionId": "7ef271d2-5958-471d-b901-c94cd2f38753",
      "token": "DUpA7zKFY9WO12nmazxnTQu003du003d",
      "username": "9691184163",
      "wsCode": "WS_findListSubBySerials",
      "wsRequest": {
        "serial": barCode,
        "language": "en",
        "token":
            "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ7XCJ1c2VybmFtZVwiOlwiUE9TTUdZMDEwMTAwMDMyNVwiLFwiY2hhbm5lbFR5cGVJZFwiOm51bGwsXCJjdXJyZW50RGF0ZVwiOlwiMDkvMTEvMjAyM1wiLFwidXNlcklkXCI6bnVsbCxcIm9iamVjdHR5cGVcIjpudWxsfSIsImlhdCI6MTY5OTU0Mjk2NiwiZXhwIjoxNzAwMTQ3NzY2fQ.A0B2LVrWkj501Q0x922oh4YePtGYnbO2qNMkK6Bi0hbzymhXqyhEG4JPYK50SvY5P1KuhqRDlp7BjbmKgZ02eg",
      },
    }),
  );

  return response;
}

// buy pack with otp and mytel pay password
Future<Response> buyPackWithOTPAndMytelPay(
  String phoneNumber,
  String accessToken,
  String otpCode,
  String packId,
) async {
  final response = await http.post(
    Uri.https("apis.mytel.com.mm", "/myid-mytelpay/v1.0/api/mytelpay/buy-pack"),
    headers: {
      "Host": "apis.mytel.com.mm",
      "sec-ch-ua": "Not_A",
      "accept": "application/json, text/plain, */*",
      "sec-ch-ua-mobile": "?1",
      "authorization": "Bearer $accessToken",
      "user-agent":
          "Mozilla/5.0 (Linux; Android 9; SM-A107F Build/PPR1.180610.011; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/120.0.6099.145 Mobile Safari/537.36",
      "sec-ch-ua-platform": "Android",
      "origin": "https://account.mytel.com.mm",
      "x-requested-with": "com.mytel.myid",
      "sec-fetch-site": "same-site",
      "sec-fetch-mode": "cors",
      "sec-fetch-dest": "empty",
      "referer": "https://account.mytel.com.mm/",
      "accept-encoding": "gzip, deflate, br",
      "accept-language": "en,en-GB",
      "Content-Type": "application/json; charset=utf-8",
    },
    body: jsonEncode({
      "phoneNo": phoneNumber,
      "pin": "111111",
      "otp": otpCode,
      "packId": packId,
      "language": "EN",
    }),
  );

  return response;
}

// 513 END

// NETWORK TEST START

Future<Response> getAllAccountsFromDB(int userId, String authToken) async {
  Map<String, String> params = {
    "userId": userId.toString(),
    "sortBy": "createdAt",
  };

  final response = await http.get(
    Uri.https(
      AuthStrings.baseUrl,
      AuthStrings.netTestGetAllAccountsRoute,
      params,
    ),
    headers: <String, String>{'authorization': "Bearer $authToken"},
  );

  return response;
}

Future<Response> getNetworkTestAvailability(
  String phoneNumber,
  String accessToken,
) async {
  Map<String, String> params = {
    "phoneNo": phoneNumber,
    "operator": "MYTEL",
    "latitude": "16.8256381",
  };

  final response = await http.get(
    Uri.https("apis.mytel.com.mm", "/network-test/v3/challenge", params),
    headers: <String, String>{
      "Authorization": "Bearer $accessToken",
      "User-Agent": "okhttp/4.9.1",
    },
  );

  return response;
}

Future<Map<String, dynamic>> submitNetworkTest(
  String phoneNumber,
  String accessToken,
  String operator,
  String requestId,
) async {
  final response = await http.post(
    Uri.https("apis.mytel.com.mm", "/network-test/v3/submit"),
    headers: <String, String>{
      "Authorization": "Bearer $accessToken",
      "User-Agent": "okhttp/4.9.1",
      "Content-Type": "application/json; charset=utf-8",
    },
    body: jsonEncode({
      "cellId": "18467",
      "deviceModel": "Redmi 6A",
      "downloadSpeed": getRandomDouble(1, 100, 2),
      "enb": "72",
      "latency": getRandomDouble(1, 100, 2),
      "latitude": "16.8256381",
      "location": "N/A",
      "longitude": "96.129527",
      "msisdn": "+95${phoneNumber.substring(1)}",
      "networkType": operator == "MYTEL" ? "_2G" : "_4G",
      "operator": operator,
      "requestId": requestId,
      "requestTime": getCurrentDateTime(),
      "rsrp": "-1",
      "township": "N/A",
      "uploadSpeed": getRandomDouble(1, 100, 2),
    }),
  );

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Response> saveNetworkTestAccount({
  required String phoneNumber,
  required String accessToken,
  required int loyaltyPoints,
  required int userId,
  required String authToken,
}) async {
  Map<String, String> params = {"userId": userId.toString()};
  var bodyJson = {
    "phoneNumber": phoneNumber,
    "accessToken": accessToken,
    "loyaltyPoints": loyaltyPoints,
  };

  final response = await http.post(
    Uri.https(AuthStrings.baseUrl, AuthStrings.netTestSaveAccountRoute, params),
    headers: <String, String>{
      'Content-Type': "application/json",
      'authorization': "Bearer $authToken",
    },
    body: jsonEncode(bodyJson),
  );

  return response;
}

void expireAccount(int id, int loyaltyPoints) async {
  try {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt(AuthStrings.appUserId);
    var authToken = prefs.getString(AuthStrings.appUserToken);

    Map<String, String> params = {"userId": userId.toString()};

    var bodyJson = {"isExpired": true, "loyaltyPoints": loyaltyPoints};

    var response = await http.post(
      Uri.https(
        AuthStrings.baseUrl,
        "${AuthStrings.netTestUpdateAccountRoute}/$id",
        params,
      ),
      headers: <String, String>{
        'Content-Type': "application/json",
        'authorization': "Bearer $authToken",
      },
      body: jsonEncode(bodyJson),
    );

    var respJson = jsonDecode(response.body);
    print("expireAccount: $respJson");
  } catch (e) {
    print("expireAccount: $e");
  }
}

Future updateLoyaltyPoints(int id, int loyaltyPoints) async {
  try {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt(AuthStrings.appUserId);
    var authToken = prefs.getString(AuthStrings.appUserToken);

    Map<String, String> params = {"userId": userId.toString()};

    var bodyJson = {"loyaltyPoints": loyaltyPoints};

    var response = await http.post(
      Uri.https(
        AuthStrings.baseUrl,
        "${AuthStrings.netTestUpdateAccountRoute}/$id",
        params,
      ),
      headers: <String, String>{
        'Content-Type': "application/json",
        'authorization': "Bearer $authToken",
      },
      body: jsonEncode(bodyJson),
    );

    var respJson = jsonDecode(response.body);
    print("updateLoyaltyPoints: $respJson");
  } catch (e) {
    print("updateLoyaltyPoints: $e");
  }
}

Future deleteFilteredAccounts(List<int> ids) async {
  try {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt(AuthStrings.appUserId);
    var authToken = prefs.getString(AuthStrings.appUserToken);

    Map<String, String> params = {"userId": userId.toString()};

    var bodyJson = {"accountIds": ids};

    var response = await http.post(
      Uri.https(
        AuthStrings.baseUrl,
        AuthStrings.netTestDeleteAllAccountsRoute,
        params,
      ),
      headers: <String, String>{
        'Content-Type': "application/json",
        'authorization': "Bearer $authToken",
      },
      body: jsonEncode(bodyJson),
    );

    var respJson = jsonDecode(response.body);
    print("updateLoyaltyPoints: $respJson");
  } catch (e) {
    print("updateLoyaltyPoints: $e");
  }
}

// NETWORK TEST END

// Buy package with Mytel Pay START
Future<Response> requestOTPForMytelPayBuyPack(
  String phoneNumber,
  String accessToken,
) async {
  Map<String, String> params = {
    "phoneNo": phoneNumber,
    "language": "EN",
    "serviceCode": "BUY_PACK",
  };

  var response = await http
      .get(
        Uri.https("apis.mytel.com.mm", "/myid-mytelpay/v2.0/api/otp", params),
        headers: {
          "Host": "apis.mytel.com.mm",
          "sec-ch-ua": "Not_A",
          "accept": "application/json, text/plain, */*",
          "sec-ch-ua-mobile": "?1",
          "authorization": "Bearer $accessToken",
          "user-agent":
              "Mozilla/5.0 (Linux; Android 9; SM-A107F Build/PPR1.180610.011; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/120.0.6099.145 Mobile Safari/537.36",
          "sec-ch-ua-platform": "Android",
          "origin": "https://account.mytel.com.mm",
          "x-requested-with": "com.mytel.myid",
          "sec-fetch-site": "same-site",
          "sec-fetch-mode": "cors",
          "sec-fetch-dest": "empty",
          "referer": "https://account.mytel.com.mm/",
          "accept-encoding": "gzip, deflate, br",
          "accept-language": "en,en-GB",
        },
      )
      .timeout(const Duration(seconds: 10));
  return response;
}

Future<Response> buyPackWithMytelPay(
  String phoneNumber,
  String accessToken,
  String pinCode,
  String otpCode,
  String packId,
) async {
  final response = await http
      .post(
        Uri.https(
          "apis.mytel.com.mm",
          "/myid-mytelpay/v2.0/api/mytelpay/buy-pack",
        ),
        headers: {
          "Host": "apis.mytel.com.mm",
          "sec-ch-ua": "Not_A",
          "accept": "application/json, text/plain, */*",
          "sec-ch-ua-mobile": "?1",
          "authorization": "Bearer $accessToken",
          "user-agent":
              "Mozilla/5.0 (Linux; Android 9; SM-A107F Build/PPR1.180610.011; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/120.0.6099.145 Mobile Safari/537.36",
          "sec-ch-ua-platform": "Android",
          "origin": "https://account.mytel.com.mm",
          "x-requested-with": "com.mytel.myid",
          "sec-fetch-site": "same-site",
          "sec-fetch-mode": "cors",
          "sec-fetch-dest": "empty",
          "referer": "https://account.mytel.com.mm/",
          "accept-encoding": "gzip, deflate, br",
          "accept-language": "en,en-GB",
          "Content-Type": "application/json; charset=utf-8",
        },
        body: jsonEncode({
          "phoneNo": phoneNumber,
          "pin": pinCode,
          "otp": otpCode,
          "packId": packId,
          "language": "EN",
        }),
      )
      .timeout(const Duration(seconds: 10));

  return response;
}
// Buy package with Mytel Pay END

// Buy normal packages START
Future<Response> buyNormalPack(
  String phoneNumber,
  String accessToken,
  String packId,
) async {
  final response = await http
      .post(
        Uri.https(
          "apis.mytel.com.mm",
          "/csm/v1.0/api/vas-package/$packId/register",
        ),
        headers: {
          "User-Agent": "okhttp/4.9.1",
          "Accept-Encoding": "gzip",
          "authorization": "Bearer $accessToken",
          "content-type": "application/json; charset=utf-8",
        },
        body: jsonEncode({
          "msisdn": "+95${phoneNumber.substring(1)}",
          "isRenew": false,
        }),
      )
      .timeout(const Duration(seconds: 10));

  return response;
}

// Buy normal packages END
