import 'dart:isolate';

import 'dart:ui';

import 'package:restaurant_app/data/api/api_restaurant_main.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

import '../main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService _service;
  static String _isolateName = 'isolate';
  static SendPort _uiSendPort;

  BackgroundService._createObject();

  factory BackgroundService() {
    if (_service == null) {
      _service = BackgroundService._createObject();
    }

    return _service;
  }

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
        port.sendPort,
        _isolateName
    );
  }

  static Future<void> callback() async {
    print('Alarm Fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await ApiRestaurantMain().mainList();
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  Future<void> someTask() async {
    print('Execute some process / MEMULAI PORT');
  }
}