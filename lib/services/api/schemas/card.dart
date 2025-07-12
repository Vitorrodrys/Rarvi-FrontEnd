import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable()
class CardCreateSchema {
  final String question;
  final String answer;
  final int discipline_id;

  CardCreateSchema({
    required this.question,
    required this.answer,
    required this.discipline_id,
  });

  Map<String, dynamic> toJson() => _$CardCreateSchemaToJson(this);
}

@JsonSerializable(includeIfNull: false)
class CardUpdateSchema {
  final String? question;
  final String? answer;
  final int? discipline_id;

  CardUpdateSchema({this.question, this.answer, this.discipline_id});

  Map<String, dynamic> toJson() => _$CardUpdateSchemaToJson(this);
}

@JsonSerializable()
class Card {
  final int id;
  final String question;
  final String? answer;
  final DateTime? last_viewed_at;
  final int discipline_id;

  Card({
    required this.id,
    required this.question,
    this.answer,
    this.last_viewed_at,
    required this.discipline_id,
  });

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
  static List<Card> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Card.fromJson(json)).toList();
  }
}

enum CardDifficultyEnum {
  again(2),
  hard(1),
  medium(0),
  easy(-1);

  final int value;

  const CardDifficultyEnum(this.value);
}
