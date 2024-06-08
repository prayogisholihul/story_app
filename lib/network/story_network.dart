import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/repository/auth_repo.dart';

import '../common/constant.dart';

class StoryNetwork {
  AuthRepository authRepository = AuthRepository();

  Future<http.Response> getStories(int page, int size) async {
    try {
      Map<String, String> queryParams = {
        'page': page.toString(),
        'size': size.toString(),
        'location': '1'
      };

      final url = Uri.parse('${Constant.baseUrl}/stories')
          .replace(queryParameters: queryParams);
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

  Future<http.Response> addStory(String filepath, String description, double? lat, double? lon) async {
    try {
      final url = Uri.parse('${Constant.baseUrl}/stories');
      final user = await authRepository.getUser();

      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Authorization': "Bearer ${user?.token ?? ''}",
        'Content-Type': 'multipart/form-data'
      });
      final file = await http.MultipartFile.fromPath('photo', filepath);
      request.files.add(file);
      request.fields['description'] = description;
      if (lat != null && lon != null) {
        request.fields['lat'] = lat.toString();
        request.fields['lon'] = lon.toString();
      }
      var response = await request.send();
      return await http.Response.fromStream(response);
    } on SocketException catch (e) {
      throw Exception(Constant.errorMessage);
    } on http.ClientException catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> getDetailStory(String id) async {
    try {
      final url = Uri.parse('${Constant.baseUrl}/stories/$id');
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
