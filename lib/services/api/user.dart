import 'package:dio/dio.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/user.dart';


class AuthInterceptor extends Interceptor {
  final String _tokenCache;
  final Dio _dio;

  AuthInterceptor({required String token, required Dio dio})
      : _dio = dio,
        _tokenCache = token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Authorization'] = 'Bearer $_tokenCache';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _dio.interceptors.removeWhere((element) => element is AuthInterceptor);
    }
    handler.next(err);
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
          throw APIError(message: message, cause: APIErrorEnum.userNotExist);
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
          throw APIError(message: message, cause: APIErrorEnum.deletionForbidden);
        case ({"detail": "A user can only update his own data"}, 403):
          throw APIError(message: message, cause: APIErrorEnum.updateForbidden);
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
          throw APIError(message: message, cause: APIErrorEnum.userNotExist);
        case ({"detail": "A user can only update his own data"}, 403):
          throw APIError(message: message, cause: APIErrorEnum.updateForbidden);
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
        throw APIError(message: message, cause: APIErrorEnum.invalidEmail);
      }
      switch ((message, statusCode)) {
        case ({"detail": "User with this email already exists"}, 400):
          throw APIError(message: message, cause: APIErrorEnum.emailAlreadyExists);
        case ({"detail": "User with this name already exists"}, 400):
          throw APIError(message: message, cause: APIErrorEnum.usernameAlreadyExists);
        default:
          rethrow;
      
      }
    }
  }

  bool _isEmail(String userIdentifier) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(userIdentifier);
  }
  Future<void> auth(String userIdentifier, String password) async {
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
        AuthInterceptor(token: response.data, dio: _dio),
      );
    } on DioException catch (e) {
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode ?? 0;
      switch ((message, statusCode)) {
        case ({"detail":"Unauthorized"}, 401):
          throw APIError(message: message, cause: APIErrorEnum.unauthorized);
        default:
          rethrow;
      }
    }
  }

  void logout() {
    _dio.interceptors.removeWhere((element) => element is AuthInterceptor);
  }
}
