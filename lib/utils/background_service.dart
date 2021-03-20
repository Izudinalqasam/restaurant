import 'dart:isolate';
import 'dart:math';

import 'dart:ui';

import 'package:submission1_fundamental/data/local/database_helper.dart';
import 'package:submission1_fundamental/data/local/local_data_source.dart';
import 'package:submission1_fundamental/data/remote/api_service.dart';
import 'package:submission1_fundamental/data/repository.dart';
import 'package:submission1_fundamental/utils/notification_helper.dart';

import '../main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService _service;
  static String _isolateNamme = 'isolate';
  static SendPort _uiSendport;

  BackgroundService._createObject();

  factory BackgroundService() {
    if (_service == null) {
      _service = BackgroundService._createObject();
    }

    return _service;
  }

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateNamme);
  }

  static Future<void> callBack() async {
    print("Background service is running");
    final random = Random();
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await Repository(
            localDataSource: LocalDataSource(databaseHelper: DatabaseHelper()),
            remoteDataSource: ApiService())
        .getRestaurant();

    var restaurant =
        result.restaurants[random.nextInt(result.restaurants.length - 1)];

    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, restaurant);

    _uiSendport ??= IsolateNameServer.lookupPortByName(_isolateNamme);
    _uiSendport?.send(null);
  }
}
