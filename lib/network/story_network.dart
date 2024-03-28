import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/repository/auth_repo.dart';

import '../common/constant.dart';

class StoryNetwork {
  AuthRepository authRepository = AuthRepository();

  Future<http.Response> getStories() async {
    try {
      final url = Uri.parse('${Constant.baseUrl}/stories');
      final user = await authRepository.getUser();
      final call = await http.get(url, headers: {
        'Authorization': "Bearer ${user?.token ?? ''}",
        'Content-Type': 'application/json'
      });
      return call;
    } on SocketException catch (e) {
      throw Exception(Constant.errorMessage);
    } on http.ClientException catch (e) {
      throw Exception(e);
    }
  }
}
