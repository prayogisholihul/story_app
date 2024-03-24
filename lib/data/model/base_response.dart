import 'dart:convert';

BaseResponse baseResultFromJson(String str) =>
    BaseResponse.fromJson(json.decode(str));

String baseResultToJson(BaseResponse data) => json.encode(data.toJson());

class BaseResponse {
  final bool error;
  final String message;

  BaseResponse({
    required this.error,
    required this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
