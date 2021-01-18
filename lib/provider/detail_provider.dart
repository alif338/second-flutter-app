import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_restaurant_detail.dart';
import 'package:restaurant_app/data/details.dart';
import 'package:restaurant_app/provider/enum/result_state.dart';


class DetailProvider extends ChangeNotifier {

  final ApiRestaurantDetail restaurantDetail;

  DetailProvider({@required this.restaurantDetail}) {
    _fetchAllDetails();
  }

  String _message = '';
  String get message => _message;

  Details _details;
  Details get result => _details;

  ResultState _states;
  ResultState get states => _states;

  Future<dynamic> _fetchAllDetails() async {
    try {
      _states = ResultState.loading;
      notifyListeners();
      final list = await restaurantDetail.detailList();
      if (list.restaurant == null) {
        _states = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _states = ResultState.HasData;
        notifyListeners();
        return _details = list;
      }
    } catch (e) {
      _states = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}