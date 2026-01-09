// ignore_for_file: constant_identifier_names

abstract class Timeouts {
  static const CONNECT_TIMEOUT = Duration(minutes: 5);
  static const RECEIVE_TIMEOUT = Duration(minutes: 5);
  static const SEND_TIMEOUT = Duration(minutes: 5);
}

abstract class ErrorMessages {
  static const badCertificate = 'Bad Certificate';
  static const cancel = 'Cancel';
  static const connectionError = 'Connection Error';
  static const error_400 = 'Bad Request';
  static const error_401 = 'You are not authorized';
  static const error_403 = 'Forbidden';
  static const error_404 = 'Not Found';
  static const error_405 = 'Method Not Allowed';
  static const error_408 = 'Request Timeout';
  static const error_409 = 'Conflict';
  static const error_410 = 'Gone';
  static const error_500 = 'Internal Server Error';
  static const error_501 = 'Not Implemented';
  static const error_502 = 'Bad Gateway';
  static const error_503 = 'Service Unavailable';
  static const error_504 = 'Gateway Timeout';
  static const error_connection_timeout = 'Connection Timeout';
  static const networkGeneral = 'Something went wrong. Please try again later.';
  static const noInternet = 'No Internet';
  static const sessionExpired = 'Session Expired';
  static const unknown = 'Unknown';
}
