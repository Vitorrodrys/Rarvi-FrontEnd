
import 'package:dio/dio.dart';


import 'package:rarvi/core/settings.dart';

import 'package:rarvi/services/api/user.dart';


class APIError implements Exception{
  final Map<String, dynamic> message;

  APIError({required this.message});
}

class RarviAPI {

  static final RarviAPI _singleton = RarviAPI._internal();
  final Dio _dio;
  late final UserAPI user;

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
  }
}