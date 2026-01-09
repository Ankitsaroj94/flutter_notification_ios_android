class APIException implements Exception {
  APIException({
    required this.message,
    this.statusCode,
    this.noInternet = false,
    this.errorBody,
  });
  final String message;
  final int? statusCode;
  final bool noInternet;
  final dynamic errorBody;
}
