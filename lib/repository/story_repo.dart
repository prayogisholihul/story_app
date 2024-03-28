import 'dart:convert';

import 'package:story_app/data/model/story_result.dart';
import 'package:story_app/network/story_network.dart';

import '../common/result.dart';
import '../data/response.dart';

class StoryRepository {
  final StoryNetwork _service = StoryNetwork();

  Future<ApiResponse<List<StoryData>>> getStories() async {
    try {
      final response = await _service.getStories();
      Map<String, dynamic> parsedJson = jsonDecode(response.body);

      final api = ApiResponse<List<StoryData>>(
        state: ResultState.Idle,
        data: List<StoryData>.from(parsedJson[StoryData.key].map((x) => StoryData.fromJson(x))),
        error: parsedJson['error'],
        message: parsedJson['message'],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
            state: ResultState.Success,
            data: api.data,
            message: api.message,
            error: api.error);
      } else {
        return ApiResponse(
            state: ResultState.Error, message: api.message, error: api.error);
      }
    } catch (e) {
      return ApiResponse(
          state: ResultState.Error, message: e.toString(), error: true);
    }
  }
}
