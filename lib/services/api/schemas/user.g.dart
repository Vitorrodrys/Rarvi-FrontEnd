// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCreateSchema _$UserCreateSchemaFromJson(Map<String, dynamic> json) =>
    UserCreateSchema(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserCreateSchemaToJson(UserCreateSchema instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };

UserUpdateSchema _$UserUpdateSchemaFromJson(Map<String, dynamic> json) =>
    UserUpdateSchema(
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserUpdateSchemaToJson(UserUpdateSchema instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };

UserAuthSchema _$UserAuthSchemaFromJson(Map<String, dynamic> json) =>
    UserAuthSchema(
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserAuthSchemaToJson(UserAuthSchema instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };
