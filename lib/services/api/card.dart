import 'package:dio/dio.dart';

import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/card.dart';



class CardAPI extends BaseAPI {

  final Dio _dio;
  CardAPI({required Dio dio}) : _dio = dio;

  Future<Card> createCard( CardCreateSchema card ) async {
    try{
      final response = await _dio.post("/v1/cards/card", data: card.toJson());
      return Card.fromJson(response.data);
    } on DioException catch (e) {
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode??0;
      if (statusCode == 422){
        throw processValidationError(message);
      }
      switch ( (message, statusCode) ){
        case ({"detail": "Discipline not found"}, 404):
          throw APIError(
            message: message,
            cause: APIErrorEnum.associatedDisciplineNotFound
          );
        case ({"detail":"Unauthorized acess to discipline"}, 403):
          throw APIError(
            message: message,
            cause: APIErrorEnum.acessNotAllowed
          );
        default:
          rethrow;
      }
    } 
  }

  Future<Card> getCard(int cardId) async {
    final response = await _dio.patch("/v1/cards/card/$cardId/view");
    return Card.fromJson(response.data);
  }

  Future<List<Card>> getCards(int? disciplineId, DateTime? fromDate, DateTime? toDate, {int skip = 0, int limit = 10}) async {
    final queryParams = {
      'skip': skip,
      'limit': limit,
      if (disciplineId != null) 'discipline_id': disciplineId,
      if (fromDate != null) 'from_date': fromDate.toIso8601String(),
      if (toDate != null) 'to_date': toDate.toIso8601String(),
    };
    final response = await _dio.get("/v1/cards/cards", queryParameters: queryParams);
    return Card.fromJsonList(response.data);
  }

  Future<int> countCards(int? disciplineId, DateTime? fromDate, DateTime? toDate) async {
    final queryParams = {
      if (disciplineId != null) 'discipline_id': disciplineId,
      if (fromDate != null) 'from_date': fromDate.toIso8601String(),
      if (toDate != null) 'to_date': toDate.toIso8601String(),
    };
    final response = await _dio.get("/v1/cards/count", queryParameters: queryParams);
    return response.data;
  }

  Future<Card> sendFeedBack(int cardId, CardDifficultyEnum cardFeedBack) async {
    final response = await _dio.patch("/v1/cards/card/$cardId/${cardFeedBack.value}");
    return Card.fromJson(response.data);
  }

  Future<Card> updateCard(int cardId, CardUpdateSchema card) async {
    try{
      final response = await _dio.patch("/v1/cards/card/$cardId", data: card.toJson());
      return Card.fromJson(response.data);
    } on DioException catch (e) {
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode??0;
      if (statusCode == 422){
        throw processValidationError(message);
      }
      switch ( (message, statusCode) ){
        case ({"detail": "card not found"}, 404):
          throw APIError(
            message: message,
            cause: APIErrorEnum.cardNotFound
          );
        case ({"detail":"Unauthorized acess to card"}, 403):
          throw APIError(
            message: message,
            cause: APIErrorEnum.acessNotAllowed
          );
        default:
          rethrow;
      }
    }
  }

  Future<Card> deleteCard(int cardId) async {
    try{
      final response = await _dio.delete("/v1/cards/card/$cardId");
      return Card.fromJson(response.data);
    } on DioException catch (e){
      dynamic message = e.response?.data;
      int statusCode = e.response?.statusCode??0;
      switch ( (message, statusCode) ){
        case ({"detail": "card not found"}, 404):
          throw APIError(
            message: message,
            cause: APIErrorEnum.cardNotFound
          );
        case ({"detail":"Unauthorized acess to card"}, 403):
          throw APIError(
            message: message,
            cause: APIErrorEnum.acessNotAllowed
          );
        default:
          rethrow;
      }
    }
  }
}