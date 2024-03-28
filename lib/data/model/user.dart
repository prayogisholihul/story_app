import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'token': token};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(email: map['email'], name: map['name'], token: map['token']);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
