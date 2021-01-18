import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_restaurant_search.dart';
import 'package:restaurant_app/data/search.dart';

enum ResStates {loading, NoData, HasData, Error}

class SearchProvider extends ChangeNotifier {
  final ApiRestaurantSearch restaurantSearch;

  SearchProvider({@required this.restaurantSearch}){
    _fetchAllSearch();
  }

  String _message = '';
  String get message => _message;

  Search _search;
  Search get result => _search;

  ResStates _state;
  ResStates get states => _state;

  Future<dynamic> _fetchAllSearch() async {
    try {
      _state = ResStates.loading;
      notifyListeners();
      final item = await restaurantSearch.searchList();
      if (item.restaurants.isEmpty) {
        _state = ResStates.NoData;
        notifyListeners();
        return _message = "No Data";
      } else {
        _state = ResStates.HasData;
        notifyListeners();
        return _search = item;
      }
    } catch (e) {
      _state = ResStates.Error;
      notifyListeners();
      return _message = "Error --> $e";
    }
  }

}