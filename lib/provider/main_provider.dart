import 'package:flutter/widgets.dart';
import 'package:story_app/common/error_message.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/data/model/story_result.dart';
import 'package:story_app/data/response.dart';
import 'package:story_app/repository/story_repo.dart';

class MainProvider extends ChangeNotifier {
  final StoryRepository storyRepo = StoryRepository();

  ApiResponse<List<StoryData>> _stories = ApiResponse(state: ResultState.Idle);

  ApiResponse<List<StoryData>> get stories => _stories;

  getStories() async {
    _stories = ApiResponse(state: ResultState.Loading);
    notifyListeners();

    final api = await storyRepo.getStories();
    if (api.state == ResultState.Success) {
      _stories = ApiResponse(state: ResultState.Success, data: api.data);
    } else {
      _stories = ApiResponse(
          state: ResultState.Error,
          message: api.message.toString().cleanedMessage);
    }
    notifyListeners();
  }

  ApiResponse _addStoryState = ApiResponse(state: ResultState.Idle);

  ApiResponse get addStoryState => _addStoryState;

  addStoryEvent(String filePath, String description) async {
    _addStoryState = ApiResponse(state: ResultState.Loading);
    notifyListeners();

    final api = await storyRepo.addStory(filePath, description);
    if (api.state == ResultState.Success) {
      _addStoryState = ApiResponse(state: ResultState.Success, data: api.data);
    } else {
      _addStoryState = ApiResponse(
          state: ResultState.Error,
          message: api.message.toString().cleanedMessage);
    }
    notifyListeners();
  }

  ApiResponse<StoryData> _detailStoryState = ApiResponse(state: ResultState.Idle);

  ApiResponse<StoryData> get detailStoryState => _detailStoryState;

  detailStoryEvent(String id) async {
    _detailStoryState = ApiResponse(state: ResultState.Loading);
    notifyListeners();

    final api = await storyRepo.getDetailStory(id);
    if (api.state == ResultState.Success) {
      _detailStoryState = ApiResponse(state: ResultState.Success, data: api.data);
    } else {
      _detailStoryState = ApiResponse(
          state: ResultState.Error,
          message: api.message.toString().cleanedMessage);
    }
    notifyListeners();
  }
}
