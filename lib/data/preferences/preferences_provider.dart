import 'package:flutter/material.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({@required this.preferencesHelper}){
    _getDailyNotifyPreferences();
  }

  bool _isDailyNotifyActive = false;
  bool get isDailyNotifyActive => _isDailyNotifyActive;

  void _getDailyNotifyPreferences() async {
    _isDailyNotifyActive = await preferencesHelper.isDailyNotifyActive;
    notifyListeners();
  }

  void enableDailyNotify(bool value) {
    preferencesHelper.setDailyNotify(value);
    _getDailyNotifyPreferences();
  }
}