import 'dart:convert';

RegisterResult registerResultFromJson(String str) => RegisterResult.fromJson(json.decode(str));

String registerResultToJson(RegisterResult data) => json.encode(data.toJson());

class RegisterResult<T> {
  final bool error;
  final String message;

  RegisterResult({
    required this.error,
    required this.message,
  });

  factory RegisterResult.fromJson(Map<String, dynamic> json) => RegisterResult(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}
