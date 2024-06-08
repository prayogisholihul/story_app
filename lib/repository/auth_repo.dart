import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/network/auth_network.dart';

import '../data/model/login_result.dart';
import '../data/model/user.dart';
import '../data/response.dart';

class AuthRepository {
  final AuthNetwork _service = AuthNetwork();

  Future<ApiResponse<LoginResult>> login(String email, String password) async {
    try {
      final response = await _service.login(email, password);

      if (response.statusCode == 200) {
        final api = ApiResponse.fromJson(json.decode(response.body),
            dataJson: (parser) => LoginResult.fromJson(parser),
            parser: LoginResult.key);
        setLogin();
        saveToken(User(email: email, name: api.data?.name ?? '', token: api.data?.token ?? ''));
        return ApiResponse(state: ResultState.Success, data: api.data, error: api.error, message: api.message);
      } else {
        final api = ApiResponse.fromJson(json.decode(response.body));
        return ApiResponse(state: ResultState.Error, error: api.error, message: api.message);
      }
    } catch (e) {
      return ApiResponse(state: ResultState.Error, error: true, message: e.toString());
    }
  }

  Future<ApiResponse> register(
      String name, String email, String password) async {
    try {
      final response = await _service.register(name, email, password);
      final data =  ApiResponse.fromJson(json.decode(response.body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(state: ResultState.Success, message: data.message, error: data.error);
      } else {
        return ApiResponse(state: ResultState.Error, message: data.message, error: data.error);
      }
    } catch (e) {
      return ApiResponse(state: ResultState.Error, message: e.toString(), error:true);
    }
  }

  // SharedPreff

  final String stateKey = "state";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 1));
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> setLogin() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(stateKey, false);
  }

  final String userKey = "user";

  Future<bool> saveToken(User user) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(userKey, user.toJsonEncode());
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    final json = preferences.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJsonDecode(json);
    } catch (e) {
      user = null;
    }
    return user;
  }
}
