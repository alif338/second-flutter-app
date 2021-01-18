import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Restaurant Enabled');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(days: 1),
        1,
        BackgroundService.callback,
        startAt: DatetimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Restaurants Disabled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}