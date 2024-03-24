import '../common/result.dart';

class ApiResponse<T> {
  final ResultState state;
  final T? data;
  final String? error;

  ApiResponse({required this.state, this.data, this.error});
}