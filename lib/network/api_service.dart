import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/data/model/login_result.dart';
import 'package:story_app/data/response.dart';

import '../common/password_hashing.dart';

class ApiService {
  static const baseUrl = 'https://story-api.dicoding.dev/v1';
  static const errorMessage = 'Oops Error!, Check Your Connection';

  Future<ApiResponse> register(
      String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    String hashedPassword = hashPassword(password);

    final response = await http.post(
      url,
      body: {
        'name': name,
        'username': email,
        'password': hashedPassword,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      final error = ApiResponse.fromJson(json.decode(response.body));
      throw Exception(error.message);
    }
  }

  Future<ApiResponse<LoginResult>> login(
      String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      String hashedPassword = hashPassword(password);
      final response =
          await http.post(url, body: {'email': email, 'password': password});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body),
            dataJson: (parser) => LoginResult.fromJson(parser),
            parser: LoginResult.key);
      } else {
        final error = ApiResponse.fromJson(json.decode(response.body));
        throw Exception(error.message);
      }
    } on SocketException catch (e) {
      throw Exception(errorMessage);
    } on http.ClientException catch (e) {
      throw Exception(e);
    }
  }
}
