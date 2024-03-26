import 'package:flutter/widgets.dart';
import 'package:story_app/common/error_message.dart';
import 'package:story_app/data/model/login_result.dart';
import 'package:story_app/repository/auth_repo.dart';

import '../common/result.dart';
import '../data/response.dart';

class AuthProvider extends ChangeNotifier {
  ApiResponse<LoginResult> _login = ApiResponse(state: ResultState.Idle);

  ApiResponse<LoginResult> get loginResult => _login;

  login(String email, String password) async {
    _login = ApiResponse(state: ResultState.Loading);
    notifyListeners();

    final api = await AuthRepository().login(email, password);
    if (api.state == ResultState.Success) {
      _login = ApiResponse(state: ResultState.Success, data: api.data);
    } else {
      _login = ApiResponse(
          state: ResultState.Error,
          message: api.message.toString().cleanedMessage);
    }
    notifyListeners();
  }

  ApiResponse _register = ApiResponse(state: ResultState.Idle);

  ApiResponse get registerResult => _register;

  register(String name, String email, String password) async {
    _register = ApiResponse(state: ResultState.Loading);
    notifyListeners();

    final api = await AuthRepository().register(name, email, password);
    if (api.state == ResultState.Success) {
      _register = ApiResponse(state: ResultState.Success, data: api.data);
    } else {
      _register = ApiResponse(
          state: ResultState.Error,
          message: api.message.toString().cleanedMessage);
    }
    notifyListeners();
  }
}
