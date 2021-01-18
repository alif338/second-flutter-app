import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper{
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({@required this.sharedPreferences});

  static const DAILY_NOTIFY = 'DAILY_NOTIFY';

  Future<bool> get isDailyNotifyActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DAILY_NOTIFY) ?? false;
  }

  void setDailyNotify(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DAILY_NOTIFY, value);
  }
}