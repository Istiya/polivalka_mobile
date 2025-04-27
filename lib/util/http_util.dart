import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class HttpUtil {
  static var authority = 'polivalka.ddns.net';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<int> loginByAuthData(
      String usernameOrEmail, String password) async {
    http.Response response = await post(Uri.http(authority, '/login'),
        {'username_or_email': usernameOrEmail, 'password': password});
    if (response.statusCode == 302) {
      Cookie cookie =
          Cookie.fromSetCookieValue(response.headers['set-cookie']!);
      _storage.write(key: 'token', value: cookie.value);
    }
    return response.statusCode;
  }

  static Future<int> registration(
      String username, String email, String password) async {
    http.Response response = await post(Uri.http(authority, '/registration'),
        {'username': username, 'email': email, 'password': password});
    if (response.statusCode == 302) {
      Cookie cookie =
          Cookie.fromSetCookieValue(response.headers['set-cookie']!);
      _storage.write(key: 'token', value: cookie.value);
    }
    return response.statusCode;
  }

  static Future<int> loginByToken() async {
    http.Response response =
        await post(Uri.http(authority, '/mobile/login'), {});
    return response.statusCode;
  }

  static Future<int> updateFamily(
      String username, bool isPlantMigration) async {
    http.Response response = await post(Uri.http(authority, '/updateFamily'), {
      'username': username,
      'isPlantMigration': isPlantMigration.toString()
    });
    return response.statusCode;
  }

  static Future<int> changeUserDara(String username, XFile? image) async {
    var formData = FormData();
    formData.fields.add(MapEntry('username', username));
    if (image != null) {
      formData.files.add(MapEntry(
        "userImage",
        await MultipartFile.fromFile(image.path,
            contentType: DioMediaType('image', 'jpg')),
      ));
    }
    final dio = Dio();
    var response = await dio.postUri(Uri.http(authority, '/changeUserData'),
        data: formData,
        options: Options(
            headers: {'cookie': 'token=${await _storage.read(key: 'token')}'},
            validateStatus: (statusCode) {
              return true;
            }));
    return response.statusCode!;
  }

  static Future<int> deletePlants(List<int> plantsIds) async {
    http.Response response = await post(Uri.http(authority, '/deletePlants'),
        {'plants_ids': plantsIds.toString()});
    return response.statusCode;
  }

  static Future<int> createFamily(String name) async {
    http.Response response =
        await post(Uri.http(authority, '/createFamily'), {'name': name});
    return response.statusCode;
  }

  static Future<int> createPlant(String name,
      {XFile? image, String? defaultImage}) async {
    var response;
    var formData = FormData();
    formData.fields.add(MapEntry('name', name));
    if (image != null) {
      formData.files.add(MapEntry(
        "plantImage",
        await MultipartFile.fromFile(image.path,
            contentType: DioMediaType('image', 'jpg')),
      ));

      final dio = Dio();
      response = await dio.postUri(Uri.http(authority, '/createPlant'),
          data: formData,
          options: Options(
              headers: {'cookie': 'token=${await _storage.read(key: 'token')}'},
              validateStatus: (statusCode) {
                return true;
              }));
    } else {
      response = await post(Uri.http(authority, '/createPlant'),
          {'name': name, 'image_path': defaultImage});
    }
    return response.statusCode!;
  }

  static Future<http.Response> post(Uri url, dynamic data) async {
    http.Response response;
    if (await _storage.read(key: 'token') == null) {
      response = await http.post(url, body: data);
    } else {
      response = await http.post(url, body: data, headers: {
        HttpHeaders.cookieHeader:
            ('token=${await _storage.read(key: 'token')}'),
        HttpHeaders.authorizationHeader: (await _storage.read(key: 'token'))!
      });
    }
    return response;
  }
}
