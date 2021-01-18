import 'dart:convert';

import 'package:restaurant_app/data/search.dart';
import 'package:http/http.dart' as http;

class ApiRestaurantSearch {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/search?q=';
  final String query;

  ApiRestaurantSearch({this.query});

  Future<Search> searchList() async {
    final response = await http.get(_baseUrl + query);
    if (response.statusCode == 200){
      return Search.fromJson(json.decode(response.body));
    } else {
      throw Exception('No such data');
    }
  }
}