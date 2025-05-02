import 'package:dio/dio.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/user.dart';


enum UserAPIErrorEnum {
  userNotExist,
  deletionForbidden,
  updateForbidden,
  emailAlreadyExists,
  usernameAlreadyExists,
  invalidEmail,
}


enum AuthErrorEnum {
  userNotFound,
  tokenExpired,
  loggedOut,
  unauthorized
}

class AuthError extends APIError{

  final AuthErrorEnum cause;

  AuthError({required Map<String, dynamic> message, required this.cause}) : super(message:message);
}

class UserError extends APIError{

  final UserAPIErrorEnum cause;
  UserError({required Map<String, dynamic> message, required this.cause}) : super(message:message);

}

class AuthInterceptor extends Interceptor {
  final String _tokenCache;
  final Dio _dio;
  Function(AuthErrorEnum) _sessionNotifier;

  AuthInterceptor({required String token, required Dio dio, required Function(AuthErrorEnum) sessionNotifier}) : 
    _tokenCache = token, 
    _dio = dio,
    _sessionNotifier = sessionNotifier; 

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Authorization'] = 'Bearer $_tokenCache';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dynamic message = err.response?.data;
    int statusCode = err.response?.statusCode ?? 0;
    _dio.interceptors.removeWhere((element) => element is AuthInterceptor);
    switch ((message, statusCode)) {
      case ({"detail":"Token expired"}, 401):
        _sessionNotifier(AuthErrorEnum.tokenExpired);
        return;
      case ({"detail": "User associated with token not found"}, 401):
        _sessionNotifier(AuthErrorEnum.userNotFound);
        return;
      case ({"detail": "IP address mismatch"}, 401):
        _sessionNotifier(AuthErrorEnum.loggedOut);
        return;
      default:
        handler.next(err);
    }
  }
}


class UserAPI {

  Dio _dio;

  UserAPI({required Dio dio}) : _dio = dio;

  Future<List<User>> getUsers() async {
    final response = await _dio.get("/v1/user/users");
    return User.fromJsonList(response.data);
  }

  Future<User> getUser(int id) async {
    try{
      final response = await _dio.get("/v1/user/user/$id");
      return User.fromJson(response.data);
    } on DioException catch (e){
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode ?? 0;
      switch ((message, statusCode)) {
        case ({"detail": "User not found"}, 404):
          throw UserError(message: message, cause: UserAPIErrorEnum.userNotExist);
        default:
          rethrow;
      }
    }
  }

  Future<User> deleteUser(int id) async {
    try{
      final response = await _dio.delete("/v1/user/user/$id");
      return User.fromJson(response.data);
    } on DioException catch (e) {
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode ?? 0;
      switch ((message, statusCode)) {
        case ({"detail": "A user can only delete themselves"}, 403):
          throw UserError(message: message, cause: UserAPIErrorEnum.deletionForbidden);
        case ({"detail": "A user can only update his own data"}, 403):
          throw UserError(message: message, cause: UserAPIErrorEnum.updateForbidden);
        default:
          rethrow;
      }
    }
  }

  Future<User> updateUser(int id, UserUpdateSchema user) async {
    try{
      final response = await _dio.patch("/v1/user/user/$id", data: user.toJson());
      return User.fromJson(response.data);
    } on DioException catch (e) {
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode ?? 0;
      switch ((message, statusCode)) {
        case ({"detail": "User not found"}, 404):
          throw UserError(message: message, cause: UserAPIErrorEnum.userNotExist);
        case ({"detail": "A user can only update his own data"}, 403):
          throw UserError(message: message, cause: UserAPIErrorEnum.updateForbidden);
        default:
          rethrow;
      }
    }
  }

  Future<User> createUser(UserCreateSchema user) async {
    try{
      final response = await _dio.post("/v1/user/user", data: user.toJson());
      return User.fromJson(response.data);
    } on DioException catch (e) {
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 422 && message['detail']?[0]['loc']?[1] == 'email') {
        throw UserError(message: message, cause: UserAPIErrorEnum.invalidEmail);
      }
      switch ((message, statusCode)) {
        case ({"detail": "User with this email already exists"}, 400):
          throw UserError(message: message, cause: UserAPIErrorEnum.emailAlreadyExists);
        case ({"detail": "User with this name already exists"}, 400):
          throw UserError(message: message, cause: UserAPIErrorEnum.usernameAlreadyExists);
        default:
          rethrow;
      
      }
    }
  }

  bool _isEmail(String userIdentifier) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(userIdentifier);
  }
  Future<void> auth(String userIdentifier, String password, Function(AuthErrorEnum) sessionNotifier) async {
    String? name, email;
    if (_isEmail(userIdentifier)) {
      email = userIdentifier;
    }else {
      name = userIdentifier;
    }
    final creds = UserAuthSchema(
      name: name,
      email: email,
      password: password
    );
    try {
      final response = await _dio.post(
        "/v1/user/auth",
        data: creds.toJson(),
      );
      _dio.interceptors.add(
        AuthInterceptor(token: response.data, dio: _dio, sessionNotifier: sessionNotifier),
      );
    } on DioException catch (e) {
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode ?? 0;
      switch ((message, statusCode)) {
        case ({"detail":"Unauthorized"}, 401):
          throw AuthError(message: message, cause: AuthErrorEnum.unauthorized);
        default:
          rethrow;
      }
    }
  }

  void logout() {
    _dio.interceptors.removeWhere((element) => element is AuthInterceptor);
  }
}
