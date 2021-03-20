import 'package:flutter/material.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';
import 'package:submission1_fundamental/data/repository.dart';
import 'package:submission1_fundamental/provider/restaurant_provider.dart';

class FavoriteProvider extends ChangeNotifier {
  final Repository repository;
  ResultState _state;
  List<Restaurants> _result;
  String _message;

  FavoriteProvider({@required this.repository}) {
    _getFovoriteRestaurant();
  }

  ResultState get state => _state;

  List<Restaurants> get result => _result;

  String get message => _message;

  Future<dynamic> _getFovoriteRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();

      final restaurants = await repository.getFavoriteRestaurants();
      if (restaurants.isNotEmpty) {
        _state = ResultState.HasData;
        notifyListeners();
        return _result = restaurants;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = "Empty Data";
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = "There is something wrong, please try again";
    }
  }
}
