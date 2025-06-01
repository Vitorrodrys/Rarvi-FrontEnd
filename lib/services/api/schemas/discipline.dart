import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discipline.g.dart';

@JsonSerializable()
class DisciplineCreateSchema {
  final String name;
  final int red;
  final int blue;
  final int green;

  DisciplineCreateSchema({required this.name, required this.red, required this.blue, required this.green});

  Map<String, dynamic> toJson() => _$DisciplineCreateSchemaToJson(this);

}

@JsonSerializable()
class DisciplineUpdateSchema {

  final String? name;
  final int? red;
  final int? blue;
  final int? green;

  DisciplineUpdateSchema({required this.name, required this.red, required this.blue, required this.green});

  Map<String, dynamic> toJson() => _$DisciplineUpdateSchemaToJson(this);

}

@JsonSerializable()
class Discipline {

  final int id;
  final String name;
  final int red;
  final int blue;
  final int green;
  final int user_id;

  Discipline({required this.id, required this.name, required this.red, required this.blue, required this.green, required this.user_id});

  factory Discipline.fromJson(Map<String, dynamic> json) => _$DisciplineFromJson(json);

  static List<Discipline> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Discipline.fromJson(json)).toList();
  }

}
