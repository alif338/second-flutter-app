import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_restaurant_main.dart';
import 'package:restaurant_app/data/restaurants.dart';
import 'package:restaurant_app/provider/enum/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiRestaurantMain restaurantMain;

  RestaurantProvider({@required this.restaurantMain}) {
    _fetchAllRestaurant();
  }

  String _message = '';
  String get message => _message;

  Restaurants _restaurant;
  Restaurants get result => _restaurant;

  ResultState _state;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final bar = await restaurantMain.mainList();
      if (bar.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurant = bar;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}