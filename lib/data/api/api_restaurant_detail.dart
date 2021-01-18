import 'dart:convert';

import 'package:restaurant_app/data/details.dart';
import 'package:http/http.dart' as http;

class ApiRestaurantDetail {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/detail/';
  final String baseId;

  ApiRestaurantDetail({this.baseId});

  Future<Details> detailList() async {
    final response = await http.get(_baseUrl + baseId);
    if (response.statusCode == 200) {
      return Details.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}