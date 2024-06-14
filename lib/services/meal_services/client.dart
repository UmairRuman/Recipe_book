import 'dart:convert';

import 'package:http/http.dart';

extension ApiResponse on Response {
  bool get isSuccessful => statusCode == 200;
}

abstract class ApiService {
  String get baseUrl => 'https://www.themealdb.com/api/json/v1/1';
  String get apiUrl;

  dynamic fetch({String endPoint = ''}) async {
    var response = await get(Uri.parse(baseUrl + apiUrl + endPoint));
    return response.isSuccessful ? jsonDecode(response.body) : null;
  }
}
