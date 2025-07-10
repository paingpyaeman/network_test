class ApiFailureException implements Exception {
  String msg;
  ApiFailureException(this.msg);
}
