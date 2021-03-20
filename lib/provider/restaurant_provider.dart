import 'package:flutter/cupertino.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';
import 'package:submission1_fundamental/data/repository.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantProvider extends ChangeNotifier {
  final Repository repository;
  List<Restaurants> _restaurantsResult;
  ResultState _state;
  String _message = '';

  RestaurantProvider({@required this.repository}) {
    _fetchRestaurants();
  }

  String get message => _message;

  ResultState get state => _state;

  List<Restaurants> get result => _restaurantsResult;

  Future<dynamic> _fetchRestaurants() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      
      final restaurant = await repository.getRestaurant();
      if (restaurant.restaurants.isNotEmpty) {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantsResult = restaurant.restaurants;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }

    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'there is a something wrong, please check your connection';
    }
  }

  Future<dynamic> searchQuestion(String query) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();

      final restaurant = await repository.searchRestaurant(query);
      if (restaurant.restaurants.isNotEmpty) {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantsResult = restaurant.restaurants;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'empty Data';
      }
    
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'there is a something wrong, please check your connection';
    }
  }
}