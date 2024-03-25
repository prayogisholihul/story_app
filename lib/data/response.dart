import '../common/result.dart';

class ApiResponse<T> {
  final ResultState state;
  final T? data;
  final bool? error;
  final String? message;

  ApiResponse({required this.state, this.data, this.error, this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json,
          {T Function(Map<String, dynamic>)? dataJson, String? parser}) =>
      ApiResponse(
        state: ResultState.Idle,
        error: json["error"],
        message: json["message"],
        data: (parser != null && dataJson != null)
            ? dataJson(json[parser])
            : null,
      );
}
