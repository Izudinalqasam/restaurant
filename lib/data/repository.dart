import 'package:submission1_fundamental/data/local/local_data_source.dart';
import 'package:submission1_fundamental/data/remote/api_service.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_detail_response.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';

class Repository {
  final ApiService remoteDataSource;
  final LocalDataSource localDataSource;

  Repository({this.remoteDataSource, this.localDataSource});

  void setNotificationSchedule(bool isScheduled) async {
    localDataSource.setNotificationSchedule(isScheduled);
  }

  Future<bool> getNotificationSchedule() async {
    return localDataSource.getNotificationSchedule();
  }
  
  Future<RestaurantResponse> getRestaurant() async {
    return remoteDataSource.getRestaurant();
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    return remoteDataSource.getRestaurantDetail(id);
  }

  Future<RestaurantResponse> searchRestaurant(String query) async {
    return remoteDataSource.searchRestaurant(query);
  }

  static String getImagePath(String pictureId) {
    return "https://restaurant-api.dicoding.dev/images/small/$pictureId";
  }

  Future<List<Restaurants>> getFavoriteRestaurants() async {
    return localDataSource.getFavoriteRestaurants();
  }

  Future<void> insertFavoriteRestaurant(Restaurants restaurants) async {
    localDataSource.insertFavoriteRestaurant(restaurants);
  }

  Future<Restaurants> getFavoriteRestaurant(String id) async {
    return localDataSource.getFavoriteRestaurant(id);
  }

  Future<void> deleteFavoriteRestaurant(String id) async {
    localDataSource.deleteFavoriteRestaurant(id);
  }
}
