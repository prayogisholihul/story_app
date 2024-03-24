import 'package:http/http.dart' as http;
import 'package:story_app/data/model/base_response.dart';
import 'package:story_app/data/model/login_result.dart';

import '../common/password_hashing.dart';
import '../data/model/register_result.dart';

class ApiService {
  static const baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<RegisterResult> register(
      String name, String email, String password) async {
    try {
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
      final data = registerResultFromJson(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data.message);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<LoginResult> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    String hashedPassword = hashPassword(password);
    final response =
        await http.post(url, body: {'email': email, 'password': password});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return loginResultFromJson(response.body);
    } else {
      final error = baseResultFromJson(response.body);
      throw Exception(error.message);
    }
  }
}
