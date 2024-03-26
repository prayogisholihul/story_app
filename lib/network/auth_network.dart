import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/common/constant.dart';

class AuthNetwork {
  Future<http.Response> register(
      String name, String email, String password) async {
    try {
      final url = Uri.parse('${Constant.baseUrl}/register');
      return await http.post(
        url,
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
    } on SocketException catch (e) {
      throw Exception(Constant.errorMessage);
    } on http.ClientException catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> login(String email, String password) async {
    try {
      final url = Uri.parse('${Constant.baseUrl}/login');
      return await http.post(url, body: {'email': email, 'password': password});
    } on SocketException catch (e) {
      throw Exception(Constant.errorMessage);
    } on http.ClientException catch (e) {
      throw Exception(e);
    }
  }
}
