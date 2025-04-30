import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserCreateSchema {
  final String name;
  final String email;
  final String password;

  UserCreateSchema({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => _$UserCreateSchemaToJson(this);

}

@JsonSerializable()
class UserUpdateSchema {
  final String? name;
  final String? email;
  final String? password;

  UserUpdateSchema({this.name, this.email, this.password});

  Map<String, dynamic> toJson() => _$UserUpdateSchemaToJson(this);
}

@JsonSerializable()
class User {

  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}

@JsonSerializable()
class UserAuthSchema {

  final String? name;
  final String? email;
  final String password;

  UserAuthSchema({this.name, this.email, required this.password});

  Map<String, dynamic> toJson() => _$UserAuthSchemaToJson(this);
}