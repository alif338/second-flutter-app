import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/restaurants.dart';
import 'package:rxdart/rxdart.dart';


final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper{

  static NotificationHelper _instance;
  int idx = Random().nextInt(20);

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  // TODO - URUTAN KEDUA ===============
  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async{
        if (payload != null) {
          // print('Notification payload : ' + payload);
          print('ANGKA DIDALAM initNotification() = ' + idx.toString());
        }
        selectNotificationSubject.add(payload);

      });
  }

  // Future<String> _downloadAndSaveFile(
  //     String url, String filename) async {
  //   var directory = await getApplicationDocumentsDirectory();
  //   var filePath = '${directory.path}/$filename';
  //   var response = await http.get(url);
  //   var file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }

  // TODO - URUTAN PERTAMA ========================
  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurants restaurants,) async {

    // idx = Random().nextInt(20);
    // var bigPicturePath = await _downloadAndSaveFile(
    //     'https://restaurant-api.dicoding.dev/images/medium/${restaurants.restaurants[idx].pictureId}',
    //     'BigPicture');
    var _channelId = '1';
    var _channelName = 'Restaurant Notifier';
    var _channelDescription = "Suggest a random of restaurants";

    // var bigPictureStyleInformation = BigPictureStyleInformation(
    //   FilePathAndroidBitmap(bigPicturePath),
    //   contentTitle: '<b>Recommended for you</b>',
    //   htmlFormatContentTitle: true,
    //   summaryText: restaurants.restaurants[idx].name,
    //   htmlFormatSummaryText: true,
    // );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true,true));

   // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, null);

    var titleNotification = "<b>Recommended For You</b>";
    var titleRestaurant = "Buka disini untuk melihat rekomendasi harian.";

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpecifics,
        payload: json.encode(restaurants.toJson()));

    print('Angka didalam showNotification() = ' + idx.toString());
  }

  // TODO - URUTAN TERAKHIR ====================
  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
        (String payload) async {
          var data = Restaurants.fromJson(json.decode(payload));
          var restaurant = data.restaurants[idx];
          Navigation.intentWithData(route, restaurant);
          print('Angka didalam configureSelectNotificationSubject() = ' + idx.toString());
        }
      );
  }
}