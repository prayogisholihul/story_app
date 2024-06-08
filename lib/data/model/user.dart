import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String email;
  final String name;
  final String token;

  User({
    required this.email,
    required this.name,
    required this.token,
  });

  @override
  String toString() => 'User(email: $email, name: $name)';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String toJsonEncode() => json.encode(toJson());

  factory User.fromJsonDecode(String source) => User.fromJson(json.decode(source));
}
