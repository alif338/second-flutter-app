// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

import 'package:restaurant_app/data/restaurant_element.dart';

class Search {
  Search({
    this.error,
    this.founded,
    this.restaurants,
  });

  bool error;
  int founded;
  List<RestaurantElement> restaurants;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    error: json["error"],
    founded: json["founded"],
    restaurants: List<RestaurantElement>.from(json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "founded": founded,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}
