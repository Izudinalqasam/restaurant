import 'package:flutter/cupertino.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_detail_response.dart';
import 'package:submission1_fundamental/data/repository.dart';
import 'package:submission1_fundamental/provider/restaurant_provider.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final Repository repository;
  RestaurantDetail _restaurantDetailResult;
  ResultState _state;
  String _message = '';
  bool _isFavorited = false;

  RestaurantDetailProvider({@required this.repository});

  String get message => _message;

  ResultState get state => _state;

  RestaurantDetail get result => _restaurantDetailResult;

  bool get isFavorited => _isFavorited;

  Future<dynamic> fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();

      final restaurant = await repository.getRestaurantDetail(id);
      if (restaurant.restaurant != null) {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantDetailResult = restaurant.restaurant;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'empty Data';
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message =
          'there is a something wrong, please check your connection';
    }
  }

  void setIsFavorite(bool isFavorite) {
    _isFavorited = isFavorite;
    notifyListeners();
  }

  Future<void> checkFavoriteRestaurant(String id) async {
    try {
      var restaurant = await repository.getFavoriteRestaurant(id);
      if (restaurant != null) {
        _isFavorited = true;
        notifyListeners();
      } else {
        _isFavorited = false;
        notifyListeners();
      }
      fetchRestaurantDetail(id);
    } catch (e) {
      _isFavorited = false;
      notifyListeners();
      fetchRestaurantDetail(id);
    }
  }

  Future<void> saveFavoriteRestaurant() async {
    try {
      repository
          .insertFavoriteRestaurant(_restaurantDetailResult.toRestaurant());
      _isFavorited = true;
      notifyListeners();
    } catch (e) {
      _isFavorited = false;
      notifyListeners();
    }
  }

  Future<void> deleteFavoriteRestaurant() async {
    try {
      repository.deleteFavoriteRestaurant(_restaurantDetailResult.id);
      _isFavorited = false;
      notifyListeners();
    } catch (e) {
      _isFavorited = true;
      notifyListeners();
    }
  }
}
