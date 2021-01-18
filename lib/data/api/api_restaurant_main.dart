import 'dart:convert';

import 'package:restaurant_app/data/restaurants.dart';
import 'package:http/http.dart' as http;

class ApiRestaurantMain {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static final String _key = 'list';
  http.Client client = http.Client();

  Future<Restaurants> mainList() async {
    final response = await client.get(_baseUrl + _key);
    if (response.statusCode == 200) {
      return Restaurants.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}