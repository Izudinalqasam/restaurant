import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:submission1_fundamental/common/navigation.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';
import 'package:submission1_fundamental/presentation/detail/restaurant_detail_page.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingAndroid =
        AndroidInitializationSettings("app_icon");

    var initializationSettingIos = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);

    var initializationSettings = InitializationSettings(
        android: initializationSettingAndroid, iOS: initializationSettingIos);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurants restaurants) async {
    print("Notification has been executed");
    var _channelId = "1";
    var _channelName = "2";
    var _channelDescription = "izzuddin news channel";

    var androidPlatformChannelSpecific = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: "ticker",
        styleInformation: DefaultStyleInformation(true, true));
    var iosPlatformChannelSpecific = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecific,
        iOS: iosPlatformChannelSpecific);

    var titleNotification = "<b>Headline Restaurant</b>";
    var titleRestaurant = restaurants.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpecifics,
        payload: json.encode(restaurants.toJson()));
  }

  void configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((event) async {
      print("Action notifiation clicked");
      var restaurant = Restaurants.fromJson(json.decode(event));
      Navigation.intentWithData(RestaurantDetailPage(
        restaurantId: restaurant.id,
      ));
    });
  }
}
