class AppStrings {
  static const String resetPassword = 'secure@519';
  static const String imei = '862798049664317';
  static const String os = 'ANDROID';
  static const String osVersion = '9.0';
}

class PrefStrings {
  static const mytelPayPinCode = "mytelPayPinCode";
  static const String isFirstTimeStart = "isFirstTimeStart";
}

class AuthStrings {
  static const String baseUrl = "solo-dev-zero.lol:3003";
  static const String loginRoute = "/api/auth/login";
  static const String profileRoute = "/api/auth/profile";
  static const String roleValidationRoute = "/api/role/validate";

  // Network Test
  static const String netTestGetAllAccountsRoute =
      "/api/network-test"; // ?userId=1
  static const String netTestSaveAccountRoute =
      "/api/network-test"; // ?userId=1
  static const String netTestUpdateAccountRoute = "/api/network-test";
  static const String netTestDeleteAccountRoute =
      "/api/network-test/delete"; // ?userId=1&netAccountId=1
  static const String netTestDeleteAllAccountsRoute =
      "/api/network-test/delete/all"; // ?userId=1

  static const String networkTestRole = "NETWORK_TEST";
  static const String scheduleRole = "POINT_CHANGE";
  static const String specialPlanPay = "SPECIAL_PLAN_PAY";

  static const myIDAccountKey = "myIDAccount";

  // login information
  static const String appUserId = "appUserId";
  static const String appUsername = "appUsername";
  static const String appUserEmail = "appUserEmail";
  static const String appUserToken = "appUserToken";
  static const String appUserFullName = "appUserFullName";
}
