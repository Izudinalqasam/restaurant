import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_detail_response.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';

class ApiService {
  static final String _list = "/list";
  static final String _detail = "/detail/";
  static final String _search = "/search";

  static final _interceptor = PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90);

  Dio dio = new Dio()
  ..interceptors.add(_interceptor)
    ..options.baseUrl = "https://restaurant-api.dicoding.dev"
    ..options.connectTimeout = 30000
    ..options.receiveTimeout = 30000;

  Future<RestaurantResponse> getRestaurant() async {
    Response response = await dio.get(_list);
    return RestaurantResponse.fromJson(response.data);
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    Response response = await dio.get(_detail + id);
    return RestaurantDetailResponse.fromJson(response.data);
  }

  Future<RestaurantResponse> searchRestaurant(String query) async {
    Response response = await dio.get(_search, queryParameters: {"q": query});
    return RestaurantResponse.fromJson(response.data);
  }

  static String getImagePath(String pictureId) {
    return "https://restaurant-api.dicoding.dev/images/small/$pictureId";
  }
}
