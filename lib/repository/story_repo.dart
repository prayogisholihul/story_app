import 'dart:convert';

import 'package:story_app/data/model/story_result.dart';
import 'package:story_app/network/story_network.dart';

import '../common/result.dart';
import '../data/response.dart';

class StoryRepository {
  final StoryNetwork _service = StoryNetwork();

  Future<ApiResponse<List<StoryData>>> getStories(int page, int size) async {
    try {
      final response = await _service.getStories(page, size);
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
      print(e);
      return ApiResponse(
          state: ResultState.Error, message: e.toString(), error: true);
    }
  }

  Future<ApiResponse> addStory(String filepath, String description, double? lat, double? lon) async {
    try {
      final response = await _service.addStory(filepath, description, lat, lon);
      final api =  ApiResponse.fromJson(json.decode(response.body));

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

  Future<ApiResponse<StoryData>> getDetailStory(String id) async {
    try {
      final response = await _service.getDetailStory(id);
      if (response.statusCode == 200) {
        final api = ApiResponse.fromJson(json.decode(response.body),
            dataJson: (parser) => StoryData.fromJson(parser),
            parser: 'story');
        return ApiResponse(state: ResultState.Success, data: api.data, error: api.error, message: api.message);
      } else {
        final api = ApiResponse.fromJson(json.decode(response.body));
        return ApiResponse(state: ResultState.Error, error: api.error, message: api.message);
      }
    } catch (e) {
      return ApiResponse(state: ResultState.Error, error: true, message: e.toString());
    }
  }
}
