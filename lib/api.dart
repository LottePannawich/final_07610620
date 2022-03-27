import "dart:convert";

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  static const BASE_URL = 'https://cpsu-test-api.herokuapp.com';

  Future<dynamic> fetch(String endPoint, {
    Map<String, dynamic>? queryParams
  }) async {
    var url = Uri.parse('$BASE_URL/$endPoint');
    final response = await http.get(url, headers: {'id': '07610620'});
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      var apiResult = ApiResult.fromJson(jsonBody);
      print(apiResult.data);
      if (apiResult.status == 'ok') {
        return apiResult.data;
      }
      else {
        throw apiResult.message!;
      }
    }
    else {
      throw "Server connection failed";
    }
  }
}

class ApiResult {

  final String status;
  final String? message;
  final dynamic data;

  ApiResult({
  required this.status,
  required this.message,
  required this.data,
  });

  factory ApiResult.fromJson(Map<String, dynamic> json) {
  return ApiResult(
  status: json["status"],
  message: json["message"],
  data: json["data"],
  );
  }
  }

