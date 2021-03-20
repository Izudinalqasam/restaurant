import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission1_fundamental/data/local/database_helper.dart';
import 'package:submission1_fundamental/data/local/preferences_key.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';

class LocalDataSource {
  DatabaseHelper databaseHelper;

  LocalDataSource({this.databaseHelper});

  void setNotificationSchedule(bool isScheduled) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(PreferencesKey.NOTIFICATION_SCHEDULE_KEY, isScheduled);
  }

  Future<bool> getNotificationSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PreferencesKey.NOTIFICATION_SCHEDULE_KEY);
  }

  Future<List<Restaurants>> getFavoriteRestaurants() async {
    return databaseHelper.getRestaurants();
  }

  Future<void> insertFavoriteRestaurant(Restaurants restaurants) async {
    databaseHelper.insertRestaurant(restaurants);
  }

  Future<Restaurants> getFavoriteRestaurant(String id) async {
    return databaseHelper.getRestaurant(id);
  }

  Future<void> deleteFavoriteRestaurant(String id) async {
    return databaseHelper.deleteRestaurant(id);
  }
}
