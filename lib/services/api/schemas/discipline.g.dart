// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discipline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisciplineCreateSchema _$DisciplineCreateSchemaFromJson(
        Map<String, dynamic> json) =>
    DisciplineCreateSchema(
      name: json['name'] as String,
      red: (json['red'] as num).toInt(),
      blue: (json['blue'] as num).toInt(),
      green: (json['green'] as num).toInt(),
    );

Map<String, dynamic> _$DisciplineCreateSchemaToJson(
        DisciplineCreateSchema instance) =>
    <String, dynamic>{
      'name': instance.name,
      'red': instance.red,
      'blue': instance.blue,
      'green': instance.green,
    };

DisciplineUpdateSchema _$DisciplineUpdateSchemaFromJson(
        Map<String, dynamic> json) =>
    DisciplineUpdateSchema(
      name: json['name'] as String?,
      red: (json['red'] as num?)?.toInt(),
      blue: (json['blue'] as num?)?.toInt(),
      green: (json['green'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DisciplineUpdateSchemaToJson(
        DisciplineUpdateSchema instance) =>
    <String, dynamic>{
      'name': instance.name,
      'red': instance.red,
      'blue': instance.blue,
      'green': instance.green,
    };

Discipline _$DisciplineFromJson(Map<String, dynamic> json) => Discipline(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      red: (json['red'] as num).toInt(),
      blue: (json['blue'] as num).toInt(),
      green: (json['green'] as num).toInt(),
      user_id: (json['user_id'] as num).toInt(),
    );

Map<String, dynamic> _$DisciplineToJson(Discipline instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'red': instance.red,
      'blue': instance.blue,
      'green': instance.green,
      'user_id': instance.user_id,
    };
