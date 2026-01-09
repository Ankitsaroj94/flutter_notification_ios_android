import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'network_handler_constants.dart';

abstract class ExceptionMaker {
  static APIException makeException(Object error) {
    if (error is APIException) {
      return error;
    }
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.sendTimeout:
          return APIException(message: ErrorMessages.error_408, statusCode: 0);

        case DioExceptionType.connectionTimeout:
          return APIException(
            message: ErrorMessages.error_connection_timeout,
            statusCode: 0,
          );

        case DioExceptionType.receiveTimeout:
          return APIException(message: ErrorMessages.error_504, statusCode: 0);

        case DioExceptionType.badResponse:
          switch (error.response?.statusCode ?? 0) {
            case 400:
              return APIException(
                message: ErrorMessages.error_400,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 401:
              return APIException(
                message: ErrorMessages.error_401,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 403:
              return APIException(
                message: ErrorMessages.error_403,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 404:
              return APIException(
                message: ErrorMessages.error_404,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 405:
              return APIException(
                message: ErrorMessages.error_405,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 408:
              return APIException(
                message: ErrorMessages.error_408,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 409:
              return APIException(
                message: ErrorMessages.error_409,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 410:
              return APIException(
                message: ErrorMessages.error_410,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 500:
              return APIException(
                message: ErrorMessages.error_500,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 501:
              return APIException(
                message: ErrorMessages.error_501,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 502:
              return APIException(
                message: ErrorMessages.error_502,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 503:
              return APIException(
                message: ErrorMessages.error_503,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            case 504:
              return APIException(
                message: ErrorMessages.error_504,
                statusCode: error.response?.statusCode,
                errorBody: error.response?.data,
              );

            default:
              return APIException(
                message: ErrorMessages.networkGeneral,
                statusCode: error.response?.statusCode,
              );
          }

        case DioExceptionType.badCertificate:
          return APIException(
            message: ErrorMessages.badCertificate,
            statusCode: error.response?.statusCode,
            errorBody: error.response?.data,
          );

        case DioExceptionType.cancel:
          return APIException(
            message: ErrorMessages.cancel,
            statusCode: error.response?.statusCode,
            errorBody: error.response?.data,
          );

        case DioExceptionType.connectionError:
          return APIException(
            message: ErrorMessages.connectionError,
            statusCode: error.response?.statusCode,
            errorBody: error.response?.data,
          );

        case DioExceptionType.unknown:
          return APIException(
            message: ErrorMessages.unknown,
            statusCode: error.response?.statusCode,
            errorBody: error.response?.data,
          );
      }
    } else {
      return APIException(message: ErrorMessages.networkGeneral);
    }
  }
}
