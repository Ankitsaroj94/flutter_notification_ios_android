import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../storage_service/storage_service.dart';
import 'api_exception.dart';
import 'network_handler.dart';

abstract mixin class NetworkHandlerBase {
  Future<Either<APIException, dynamic>> get({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
  }) => NetworkHandler.get(path: path, query: query, data: data);

  Future<Either<APIException, dynamic>> post({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
  }) => NetworkHandler.post(path: path, data: data, query: query);

  Future<Either<APIException, dynamic>> getAuth({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
  }) => NetworkHandler.getAuth(path: path, query: query, data: data);

  Future<Either<APIException, dynamic>> postAuth({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
  }) => NetworkHandler.postAuth(path: path, query: query, data: data);

  Future<Either<APIException, dynamic>> postMultipart({
    required String path,
    Map<String, dynamic>? query,
    FormData? data,
    Function(double progress)? onSendProgress,
    Function(double progress)? onReceiveProgress,
  }) => NetworkHandler.postMultipart(
    path: path,
    query: query,
    data: data,
    onReceiveProgress: onReceiveProgress,
    onSendProgress: onSendProgress,
  );

  Future<Either<APIException, dynamic>> postMultipartAuth({
    required String path,
    Map<String, dynamic>? query,
    FormData? data,
    Function(double progress)? onSendProgress,
    Function(double progress)? onReceiveProgress,
  }) => NetworkHandler.postMultipartAuth(
    path: path,
    query: query,
    data: data,
    onReceiveProgress: onReceiveProgress,
    onSendProgress: onSendProgress,
  );

  static Dio get noBaseDio => NetworkHandler.nonBaseDio;

  void closeAllDioClients() => NetworkHandler.closeAllClients();

  num? get rn => StorageService.getUserData()?.rn;
  num? get orgid => StorageService.getUserData()?.orgid;
  num? get locid => StorageService.getUserData()?.locid;
  num? get siteid => StorageService.getUserData()?.siteid;
  num? get staffid => StorageService.getUserData()?.staffid;
  num? get acadyear => StorageService.getUserData()?.acadyear;
  num? get usersysid => StorageService.getUserData()?.usersysid;
  num? get accessLevel => StorageService.getUserData()?.accessLevel;
  num? get staffNumber => StorageService.getUserData()?.staffNumber;
  num? get returnNumber => StorageService.getUserData()?.returnNumber;

  String? get rm => StorageService.getUserData()?.rm;
  String? get hrflag => StorageService.getUserData()?.hrflag;
  String? get userid => StorageService.getUserData()?.userid;
  String? get orgLogo => StorageService.getUserData()?.orgLogo;
  String? get acadname => StorageService.getUserData()?.acadname;
  String? get photoPath => StorageService.getUserData()?.photoPath;
  String? get staffname => StorageService.getUserData()?.staffname;
  String? get payrollflag => StorageService.getUserData()?.payrollflag;
  String? get schoolName => StorageService.getUserData()?.schoolName;
  String? get schoolLogo => StorageService.getUserData()?.schoolLogo;
}
