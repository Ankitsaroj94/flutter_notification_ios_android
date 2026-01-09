import 'dart:developer';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:synchronized/synchronized.dart';

import '../../modules/auth/login/data/repo/login_repo.dart';
import '../global_service.dart';
import '../token_service.dart';
import 'api_exception.dart';
import 'api_routes.dart';
import 'exception_maker.dart';
import 'network_handler_constants.dart';

abstract class NetworkHandler {
  // Dio Clients
  static Dio? _dio;
  static Dio? _dioAuth;
  static Dio? _dioMultipart;
  static Dio? _dioMultipartAuth;
  static Dio? _noBaseDio;

  // Connectivity
  static Connectivity? _connectivity;

  // Token refresh lock
  static final _tokenRefreshLock = Lock();

  // Dio Logger
  static final PrettyDioLogger prettyDioLogger = PrettyDioLogger(
    requestBody: true,
    requestHeader: true,
    responseHeader: true,
    logPrint: (object) => kReleaseMode
        // ignore: avoid_print
        ? print(object.toString())
        : log(object.toString(), name: 'API_LOG'),
  );

  // Base Options
  static BaseOptions get _dioOptions => BaseOptions(
    connectTimeout: Timeouts.CONNECT_TIMEOUT,
    receiveTimeout: Timeouts.RECEIVE_TIMEOUT,
    sendTimeout: Timeouts.SEND_TIMEOUT,
    baseUrl: ApiRoutes.base,
    contentType: Headers.jsonContentType,
    headers: {'Accept': Headers.jsonContentType},
  );

  static BaseOptions get _dioMultipartOptions => BaseOptions(
    connectTimeout: Timeouts.CONNECT_TIMEOUT,
    receiveTimeout: Timeouts.RECEIVE_TIMEOUT,
    sendTimeout: Timeouts.SEND_TIMEOUT,
    baseUrl: ApiRoutes.base,
    contentType: Headers.jsonContentType,
    headers: {'Accept': Headers.multipartFormDataContentType},
  );

  // Dio Getters
  static Dio get nonBaseDio => _noBaseDio ??= _createNoBaseDio;
  static Dio get _client => _dio ??= _createDio;
  static Dio get _authClient => _dioAuth ??= _createDioAuth;
  static Dio get _multipartClient => _dioMultipart ??= _createDioMultipart;
  static Dio get _multipartAuthClient =>
      _dioMultipartAuth ??= _createDioMultipartAuth;

  // Dio Creators
  static Dio get _createNoBaseDio =>
      Dio()..interceptors.addAll([ChuckerDioInterceptor(), prettyDioLogger]);

  static Dio get _createDio =>
      Dio(_dioOptions)
        ..interceptors.addAll([ChuckerDioInterceptor(), prettyDioLogger]);

  static Dio get _createDioAuth => Dio(_dioOptions)
    ..interceptors.addAll([
      ChuckerDioInterceptor(),
      prettyDioLogger,
      authInterceptor,
    ]);

  static Dio get _createDioMultipart =>
      Dio(_dioMultipartOptions)
        ..interceptors.addAll([ChuckerDioInterceptor(), prettyDioLogger]);

  static Dio get _createDioMultipartAuth => Dio(_dioMultipartOptions)
    ..interceptors.addAll([
      ChuckerDioInterceptor(),
      prettyDioLogger,
      authInterceptor,
    ]);

  // Connectivity Check
  static Future<bool> _isNetworkNotAvailable() async {
    _connectivity ??= Connectivity();
    final connectivity = await _connectivity!.checkConnectivity();
    return connectivity.contains(ConnectivityResult.none);
  }

  // Error Logger
  static void _errorLogger(Object? object, [StackTrace? stackTrace]) => log(
    object.toString(),
    name: 'API_EXCEPTION_LOGS',
    stackTrace: stackTrace,
  );

  // Auth Interceptor
  static InterceptorsWrapper get authInterceptor => InterceptorsWrapper(
    onRequest: (options, handler) async {
      final jwt = await TokenService.getJwtToken();
      if (jwt != null) {
        options.headers['Authorization'] = 'Bearer $jwt';
      }
      handler.next(options);
    },
    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        await _tokenRefreshLock.synchronized(() async {
          final currentToken = await TokenService.getJwtToken();
          final requestToken = error.requestOptions.headers['Authorization']
              ?.toString();

          if (currentToken == null || requestToken == 'Bearer $currentToken') {
            try {
              final refreshResponse = await _fetchNewAccessToken();
              return refreshResponse.fold(
                (left) {
                  handler.reject(error);
                  GlobalService.expireSession();
                },
                (right) async {
                  final response = await _retry(error.requestOptions);
                  return handler.resolve(response);
                },
              );
            } catch (e, stackTrace) {
              _errorLogger(e, stackTrace);
              return handler.reject(error);
            }
          } else {
            final response = await _retry(error.requestOptions);
            return handler.resolve(response);
          }
        });
      } else {
        return handler.next(error);
      }
    },
  );

  // Token Refresh Logic
  static Future<Either<APIException, bool>> _fetchNewAccessToken() async {
    final response = await LoginRepo().autoLogin();
    return response.fold(
      (left) {
        return Left(left);
      },
      (right) {
        if (!right) {
          return Left(ExceptionMaker.makeException(right));
        }
        return Right(right);
      },
    );
  }

  // Retry Request
  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _authClient.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // Request Methods
  static Future<Either<APIException, dynamic>> get({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
  }) async {
    try {
      final response = await _client.get(
        path,
        queryParameters: query,
        data: data,
      );
      return Right(response.data);
    } catch (e, stackTrace) {
      return await _handleException(e, stackTrace);
    }
  }

  static Future<Either<APIException, dynamic>> post({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
  }) async {
    try {
      final response = await _client.post(
        path,
        queryParameters: query,
        data: data,
      );
      return Right(response.data);
    } catch (e, stackTrace) {
      return await _handleException(e, stackTrace);
    }
  }

  static Future<Either<APIException, dynamic>> getAuth({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
  }) async {
    try {
      final response = await _authClient.get(
        path,
        queryParameters: query,
        data: data,
      );
      return Right(response.data);
    } catch (e, stackTrace) {
      return await _handleException(e, stackTrace);
    }
  }

  static Future<Either<APIException, dynamic>> postAuth({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
  }) async {
    try {
      final response = await _authClient.post(
        path,
        queryParameters: query,
        data: data,
      );
      return Right(response.data);
    } catch (e, stackTrace) {
      return await _handleException(e, stackTrace);
    }
  }

  static Future<Either<APIException, dynamic>> postMultipart({
    required String path,
    Map<String, dynamic>? query,
    FormData? data,
    Function(double progress)? onSendProgress,
    Function(double progress)? onReceiveProgress,
  }) async {
    try {
      final response = await _multipartClient.post(
        path,
        queryParameters: query,
        data: data,
        onSendProgress: (count, total) => onSendProgress?.call(count / total),
        onReceiveProgress: (count, total) =>
            onReceiveProgress?.call(count / total),
      );
      return Right(response.data);
    } catch (e, stackTrace) {
      return await _handleException(e, stackTrace);
    }
  }

  static Future<Either<APIException, dynamic>> postMultipartAuth({
    required String path,
    Map<String, dynamic>? query,
    FormData? data,
    Function(double progress)? onSendProgress,
    Function(double progress)? onReceiveProgress,
  }) async {
    try {
      final response = await _multipartAuthClient.post(
        path,
        queryParameters: query,
        data: data,
        options: Options(headers: {'Accept': '*/*'}),
        onSendProgress: (count, total) => onSendProgress?.call(count / total),
        onReceiveProgress: (count, total) =>
            onReceiveProgress?.call(count / total),
      );
      return Right(response.data);
    } catch (e, stackTrace) {
      return await _handleException(e, stackTrace);
    }
  }

  // Exception Handling
  static Future<Left<APIException, dynamic>> _handleException(
    Object e,
    StackTrace stackTrace,
  ) async {
    _errorLogger(e, stackTrace);
    final isOffline = await _isNetworkNotAvailable();
    if (isOffline) {
      return Left(
        APIException(message: ErrorMessages.noInternet, noInternet: true),
      );
    }
    return Left(ExceptionMaker.makeException(e));
  }

  // Cleanup
  static void closeAllClients() {
    _dio?.close();
    _dio = null;
    _dioAuth?.close();
    _dioAuth = null;
    _dioMultipart?.close();
    _dioMultipart = null;
    _dioMultipartAuth?.close();
    _dioMultipartAuth = null;
  }
}
