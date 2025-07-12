// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardCreateSchema _$CardCreateSchemaFromJson(Map<String, dynamic> json) =>
    CardCreateSchema(
      question: json['question'] as String,
      answer: json['answer'] as String,
      discipline_id: (json['discipline_id'] as num).toInt(),
    );

Map<String, dynamic> _$CardCreateSchemaToJson(CardCreateSchema instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      'discipline_id': instance.discipline_id,
    };

CardUpdateSchema _$CardUpdateSchemaFromJson(Map<String, dynamic> json) =>
    CardUpdateSchema(
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      discipline_id: (json['discipline_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CardUpdateSchemaToJson(CardUpdateSchema instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('question', instance.question);
  writeNotNull('answer', instance.answer);
  writeNotNull('discipline_id', instance.discipline_id);
  return val;
}

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      id: (json['id'] as num).toInt(),
      question: json['question'] as String,
      answer: json['answer'] as String?,
      last_viewed_at: json['last_viewed_at'] == null
          ? null
          : DateTime.parse(json['last_viewed_at'] as String),
      discipline_id: (json['discipline_id'] as num).toInt(),
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'last_viewed_at': instance.last_viewed_at?.toIso8601String(),
      'discipline_id': instance.discipline_id,
    };
