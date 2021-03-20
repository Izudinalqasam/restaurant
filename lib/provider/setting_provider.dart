import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:submission1_fundamental/data/repository.dart';
import 'package:submission1_fundamental/utils/background_service.dart';
import 'package:submission1_fundamental/utils/date_time_helper.dart';

class SettingProvider extends ChangeNotifier {
  final Repository repository;
  bool _isNotificationOn = false;
  String _message = "";

  SettingProvider({@required this.repository});

  bool get notificationStatus => _isNotificationOn;

  String get message => _message;

  Future<dynamic> getRestaurantNotificationState() async {
    try {
      var state = await repository.getNotificationSchedule() ?? false;
      _isNotificationOn = state;
      notifyListeners();
    } catch (e) {
      _isNotificationOn = false;
      _message = e.message;
      notifyListeners();
    }
  }

  Future<dynamic> setRestaurantNotification(bool status) async {
    try {
      repository.setNotificationSchedule(status);
      _isNotificationOn = status;
      notifyListeners();

      if (_isNotificationOn) {
        print("Notification has been scheduled");
        return await AndroidAlarmManager.periodic(
            Duration(hours: 24), 1, BackgroundService.callBack,
            startAt: DateTimeHelper.format(), exact: true, wakeup: true);
      } else {
        return await AndroidAlarmManager.cancel(1);
      }
    } catch (e) {
      _isNotificationOn = false;
      _message = e.message;
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
