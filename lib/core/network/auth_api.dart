import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:network_test/core/exceptions/auth_failure_exception.dart';
import 'package:network_test/core/utils/constants.dart';
import 'package:network_test/core/utils/util.dart';
import 'package:network_test/features/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Response> login(String username, String password) async {
  var bodyJson = {"username": username, "password": password};

  final response = await http.post(
    Uri.https(AuthStrings.baseUrl, AuthStrings.loginRoute),
    headers: <String, String>{
      'Connection': "Keep-Alive",
      'Accept-Encoding': "gzip",
      'Content-Type': "application/json",
    },
    body: jsonEncode(bodyJson),
  );

  return response;
}

Future<Response> profile(String token, String username, String role) async {
  Map<String, String> params = {
    "username": username,
    // "role": role,
  };

  final response = await http.get(
    Uri.https(AuthStrings.baseUrl, AuthStrings.profileRoute, params),
    headers: <String, String>{
      'User-Agent': "okhttp/3.12.1",
      'Connection': "Keep-Alive",
      'Accept-Encoding': "gzip",
      'accept-language': "mu",
      'content-type': "application/json",
      'authorization': "Bearer $token",
    },
  );

  return response;
}

Future<Response> validateRole(
  String token,
  String username,
  String role,
) async {
  Map<String, String> params = {"username": username, "role": role};

  final response = await http.get(
    Uri.https(AuthStrings.baseUrl, AuthStrings.roleValidationRoute, params),
    headers: <String, String>{
      'User-Agent': "okhttp/3.12.1",
      'Connection': "Keep-Alive",
      'Accept-Encoding': "gzip",
      'accept-language': "mu",
      'content-type': "application/json",
      'authorization': "Bearer $token",
    },
  );

  return response;
}

Future checkAuthentication(User? user, String role) async {
  if (user == null) {
    throw AuthFailureException("Please Login");
  }
  var token = user.token;
  var username = user.username;

  if (token.isEmpty || username.isEmpty) {
    throw AuthFailureException("Please Login");
  }

  var profileResp = await profile(token, username, role);
  if (profileResp.statusCode != 200) {
    throw AuthFailureException("Please Login");
  }

  var profileRespJson = utf8JsonDecode(profileResp);
  var roles = profileRespJson["roles"];

  var isAuthorized = false;
  for (var role in roles) {
    if (role == AuthStrings.networkTestRole) {
      isAuthorized = true;
      break;
    }
  }

  if (!isAuthorized) {
    throw AuthFailureException("Please Login");
  }
}

Future checkAuth(String role) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString(AuthStrings.appUserToken);
  var username = prefs.getString(AuthStrings.appUsername);

  if (token == null || token.isEmpty) {
    throw AuthFailureException("Please Login");
  }

  if (username == null || username.isEmpty) {
    throw AuthFailureException("Please Login");
  }

  var profileResp = await profile(token, username, role);
  if (profileResp.statusCode != 200) {
    throw AuthFailureException("Please Login");
  }

  var profileRespJson = utf8JsonDecode(profileResp);
  var roles = profileRespJson["roles"];

  // logger.i(profileRespJson);
  var isAuthorized = false;
  for (var role in roles) {
    if (role == AuthStrings.networkTestRole) {
      isAuthorized = true;
      break;
    }
  }

  if (!isAuthorized) {
    throw AuthFailureException("Please Login");
  }
}
