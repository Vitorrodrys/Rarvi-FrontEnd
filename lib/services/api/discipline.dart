import 'package:dio/dio.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/card.dart';
import 'package:rarvi/services/api/schemas/discipline.dart';



class DisciplineAPI extends BaseAPI {

  final Dio _dio;
  DisciplineAPI({required Dio dio}) : _dio = dio;

  Future<Discipline> createDiscipline(DisciplineCreateSchema discipline) async {
    try{
      final response = await _dio.post("/v1/disciplines/discipline", data:discipline.toJson());
      return Discipline.fromJson(response.data);
    } on DioException catch (e){
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode??0;
      if (statusCode == 422){
        throw processValidationError(message);
      }
      switch ( (message, statusCode) ){
        case ({"detail": "discipline with this name already exists"}, 409):
          throw APIError(
            message: message,
            cause: APIErrorEnum.disciplineAlreadyExist
          );
        default:
          rethrow;
      }
    }
  }

  Future<List<Discipline>> getUserDisciplines({int skip=0, int limit=10}) async {
    final queryParams = {
      'skip': skip,
      'limit': limit
    };
    final response = await _dio.get("/v1/disciplines/disciplines", queryParameters: queryParams);
    return Discipline.fromJsonList(response.data);
  }

  Future<Discipline> updateDiscipline(int disciplineId, DisciplineCreateSchema discipline) async {
    try{
      final response = await _dio.patch("/v1/disciplines/discipline/$disciplineId", data:discipline.toJson());
      return Discipline.fromJson(response.data);
    } on DioException catch (e){
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode??0;
      if (statusCode == 422){
        throw processValidationError(message);
      }
      switch ( (message, statusCode) ){
        case ({"detail": "The name of the discipline is already in using"}, 409):
          throw APIError(
            message: message,
            cause: APIErrorEnum.disciplineAlreadyExist
          );
        default:
          rethrow;
      }
    }
  }

  Future<Discipline> deleteDiscipline(int disciplineId) async {
    try{
      final response = await _dio.delete("/v1/disciplines/discipline/$disciplineId");
      return Discipline.fromJson(response.data);
    } on DioException catch (e) {
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode??0;
      switch ((message, statusCode)){
        case ({"detail": "Cannot delete the disciplines because it had related cards"}, 409):
          throw APIError(
            message: message,
            cause: APIErrorEnum.disciplineDeleteConflict
          );
        default:
          rethrow;
      }
    }
  }

  Future <Card> getRandomByDiscipline(int disciplineId) async{
    try{
      final response = await _dio.patch("/v1/disciplines/discipline/$disciplineId/random-card/view");
      return Card.fromJson(response.data);
    } on DioException catch (e){
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode??0;
      switch ((message, statusCode)){
        case ({"detail": "No cards associated with discipline given"}, 404):
          throw APIError(
            message: message,
            cause: APIErrorEnum.emptyDiscipline
          );
        default:
          rethrow;
      }
    }
  }
}