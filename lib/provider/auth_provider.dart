import 'package:flutter/widgets.dart';
import 'package:story_app/data/model/login_result.dart';
import 'package:story_app/network/api_service.dart';

import '../common/result.dart';
import '../data/response.dart';

class AuthProvider extends ChangeNotifier {
  ApiResponse<LoginResult> _apiResponse = ApiResponse(state: ResultState.Idle);

  ApiResponse<LoginResult> get apiResponse => _apiResponse;

  login(String email, String password) async {
    _apiResponse = ApiResponse(state: ResultState.Loading);
    notifyListeners();

    try {
      final data = await ApiService().login(email, password);
      _apiResponse = ApiResponse(state: ResultState.Success, data: data);
    } catch (e) {
      int colonIndex = e.toString().indexOf(':');
      String cleanedMessage = e.toString().substring(colonIndex + 2).trim();
      _apiResponse = ApiResponse(state: ResultState.Error, error: cleanedMessage);
      print(e);
    } finally {
      notifyListeners();
    }
  }
}
