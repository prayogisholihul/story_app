import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:story_app/common/error_message.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/data/model/story_result.dart';
import 'package:story_app/data/response.dart';
import 'package:story_app/repository/story_repo.dart';

class MainProvider extends ChangeNotifier {
  final StoryRepository storyRepo = StoryRepository();

  final pageSize = 5;

  final PagingController<int, StoryData> pagingController =
      PagingController(firstPageKey: 1);

  getStories() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  refreshHome() {
    pagingController.refresh();
  }

  Future<void> fetchPage(int pageKey) async {
    final api = await storyRepo.getStories(pageKey, pageSize);

    if (api.state == ResultState.Success) {
      final isLastPage = api.data!.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(api.data ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(api.data ?? [], nextPageKey);
      }
    }

    if (api.state == ResultState.Error) {
      pagingController.error = api.message;
    }
  }

  ApiResponse _addStoryState = ApiResponse(state: ResultState.Idle);

  ApiResponse get addStoryState => _addStoryState;

  addStoryEvent(String filePath, String description, double? lat, double? lon) async {
    _addStoryState = ApiResponse(state: ResultState.Loading);
    notifyListeners();

    final api = await storyRepo.addStory(filePath, description, lat , lon);
    if (api.state == ResultState.Success) {
      _addStoryState = ApiResponse(state: ResultState.Success, data: api.data);
    } else {
      _addStoryState = ApiResponse(
          state: ResultState.Error,
          message: api.message.toString().cleanedMessage);
    }
    notifyListeners();
  }

  addStoryToIdle() {
    _addStoryState = ApiResponse(state: ResultState.Idle);
    notifyListeners();
  }

  ApiResponse<StoryData> _detailStoryState =
      ApiResponse(state: ResultState.Idle);

  ApiResponse<StoryData> get detailStoryState => _detailStoryState;

  detailStoryEvent(String id) async {
    _detailStoryState = ApiResponse(state: ResultState.Loading);
    notifyListeners();

    final api = await storyRepo.getDetailStory(id);
    if (api.state == ResultState.Success) {
      _detailStoryState =
          ApiResponse(state: ResultState.Success, data: api.data);
    } else {
      _detailStoryState = ApiResponse(
          state: ResultState.Error,
          message: api.message.toString().cleanedMessage);
    }
    notifyListeners();
  }
}
