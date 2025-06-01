
import 'package:dio/dio.dart';


import 'package:rarvi/core/settings.dart';
import 'package:rarvi/services/api/card.dart';
import 'package:rarvi/services/api/discipline.dart';
import 'package:rarvi/services/api/user.dart';

enum APIErrorEnum {

  //connection errors
  timeout,
  receiveTimeout,
  connectionError,

  //permission errors
  acessNotAllowed,

  //validation errors
  validationSchemaError,

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
  unauthorized,

  //card errors
  associatedDisciplineNotFound,
  cardNotFound,

  //discipline errors
  disciplineAlreadyExist,
  disciplineDeleteConflict,
  emptyDiscipline;
}

class APIError implements Exception{
  final Map<String, dynamic> message;
  final APIErrorEnum cause;

  APIError({required this.message, required this.cause});
}

class _ErrorHandler extends Interceptor {

  final Map<APIErrorEnum, Map<String, Function(APIErrorEnum)>> _onErrorMapping ;
  _ErrorHandler(this._onErrorMapping);

  void _warningAll(APIErrorEnum error){
    for (var listener in (_onErrorMapping[error] ?? {}).values) {
      listener(error);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dynamic message = err.response?.data;
    int statusCode = err.response?.statusCode ?? 0;
    if (err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.receiveTimeout) {
      _warningAll(APIErrorEnum.timeout);
      handler.reject(err);
      return;
    }
    if (err.type == DioExceptionType.connectionError){
      _warningAll(APIErrorEnum.connectionError);
      handler.reject(err);
      return;
    }
    switch ((message, statusCode)) {
      case ({"detail":"Token expired"}, 401):
        _warningAll(APIErrorEnum.tokenExpired);
        handler.next(err);//trigger the next interceptor
        return;
      case ({"detail": "User associated with token not found"}, 401):
        _warningAll(APIErrorEnum.userNotFound);
        handler.next(err);//trigger the next interceptor
        return;
      case ({"detail": "IP address mismatch"}, 401):
        _warningAll(APIErrorEnum.loggedOut);
        handler.next(err);//trigger the next interceptor
        return;
      default:
        handler.next(err);//trigger the next interceptor
    }
  }
}

abstract class BaseAPI {
  /// This method should only be called by subclasses of BaseAPI.
  /// It interprets a FastAPI validation error and converts it into a map like:
  ///
  /// {
  ///   "invalid_field": {"cause": "validation error cause", ...other useful fields}
  /// }
  ///
  /// Returns an APIError instance with the formatted error map as its message.
  APIError processValidationError(Map<String, dynamic> errorMessage) {
    List<Map<String, dynamic>> errorDetail = errorMessage['detail'];
    Map<String, Map<String, dynamic>> errorFormatted = {};

    for (var value in errorDetail) {
      errorFormatted[value['loc'][1]] = {
        "cause": value['type'],
        ...value['ctx'],
      };
    }

    return APIError(
      message: errorFormatted,
      cause: APIErrorEnum.validationSchemaError,
    );
  }
}

class RarviAPI {

  static final RarviAPI _singleton = RarviAPI._internal();
  final Dio _dio;
  late final UserAPI user;
  late final CardAPI card;
  late final DisciplineAPI discipline;
  final Map<String, List<APIErrorEnum>> _listenersTypeMapping = {};
  final Map<APIErrorEnum, Map<String, Function(APIErrorEnum)>> _onErrorMapping = {};

  factory RarviAPI() {
    return _singleton;
  }

  RarviAPI._internal() : 
  _dio = Dio(
    BaseOptions(
      baseUrl: Settings.apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) => status != null && status >= 200 && status < 300
    )
  ){

    user = UserAPI(dio: _dio);
    card = CardAPI(dio: _dio);
    discipline = DisciplineAPI(dio: _dio);

    _dio.interceptors.add(_ErrorHandler(_onErrorMapping));
  }

  void addSessionListener(String name, Function(APIErrorEnum) listener, List<APIErrorEnum> onError){
    _listenersTypeMapping[name] = onError;
    Map<String, Function(APIErrorEnum)>? onErrorListeners;
    for (var error in onError) {
      onErrorListeners = _onErrorMapping[error] ?? {};
      onErrorListeners[name] = listener;
      _onErrorMapping[error] = onErrorListeners;
    }
  }

  void removeSessionListener(String name){
    List<APIErrorEnum>? listenerTypeErrors = _listenersTypeMapping[name];
    for (var error in listenerTypeErrors ?? []) {
      _onErrorMapping[error]?.remove(name);
      if (_onErrorMapping[error]?.isEmpty ?? false) {
        _onErrorMapping.remove(error);
      }
    } 
  }
}