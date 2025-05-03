
import 'package:dio/dio.dart';


import 'package:rarvi/core/settings.dart';
import 'package:rarvi/services/api/user.dart';

enum APIErrorEnum {

  //connection errors
  timeout,
  receiveTimeout,
  connectionError,


  //user errors
  userNotExist,
  deletionForbidden,
  updateForbidden,
  emailAlreadyExists,
  usernameAlreadyExists,
  invalidEmail,

  //auth errors
  userNotFound,
  tokenExpired,
  loggedOut,
  unauthorized
}

class APIError implements Exception{
  final Map<String, dynamic> message;
  final APIErrorEnum cause;

  APIError({required this.message, required this.cause});
}

class _ErrorHandler extends Interceptor {

  final Map<String, Function(APIErrorEnum)> _sessionListeners;
  _ErrorHandler(this._sessionListeners);

  void _warningAll(APIErrorEnum error){
    for (var listener in _sessionListeners.values) {
      listener(error);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dynamic message = err.response?.data;
    int statusCode = err.response?.statusCode ?? 0;
    if (err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.receiveTimeout) {
      _warningAll(APIErrorEnum.timeout);
      handler.next(err);
      return;
    }
    if (err.type == DioExceptionType.connectionError){
      _warningAll(APIErrorEnum.connectionError);
      handler.next(err);
      return;
    }
    switch ((message, statusCode)) {
      case ({"detail":"Token expired"}, 401):
        _warningAll(APIErrorEnum.tokenExpired);
        return;
      case ({"detail": "User associated with token not found"}, 401):
        _warningAll(APIErrorEnum.userNotFound);
        return;
      case ({"detail": "IP address mismatch"}, 401):
        _warningAll(APIErrorEnum.loggedOut);
        return;
      default:
        handler.next(err);
    }
  }
}

class RarviAPI {

  static final RarviAPI _singleton = RarviAPI._internal();
  final Dio _dio;
  late final UserAPI user;
  final Map<String, Function(APIErrorEnum)> _sessionListeners = {};

  factory RarviAPI() {
    return _singleton;
  }

  RarviAPI._internal() : 
  _dio = Dio(
    BaseOptions(
      baseUrl: Settings.apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) => status == 200
    )
  ){

    user = UserAPI(dio: _dio);

    _dio.interceptors.add(_ErrorHandler(_sessionListeners));
  }

  void addSessionListener(String name, Function(APIErrorEnum) listener){
    _sessionListeners[name] = listener;
  }

  void removeSessionListener(String name){
    _sessionListeners.remove(name);
  }
}