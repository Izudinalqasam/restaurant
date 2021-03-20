import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission1_fundamental/data/local/database_helper.dart';
import 'package:submission1_fundamental/data/local/local_data_source.dart';
import 'package:submission1_fundamental/data/remote/api_service.dart';
import 'package:submission1_fundamental/data/repository.dart';
import 'package:submission1_fundamental/provider/restaurant_detail_provider.dart';
import 'package:submission1_fundamental/provider/restaurant_provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({Key key, this.restaurantId}) : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  Repository _repository = Repository(
      remoteDataSource: ApiService(),
      localDataSource: LocalDataSource(databaseHelper: DatabaseHelper()));

  RestaurantDetailProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = RestaurantDetailProvider(repository: _repository);
    _provider.checkFavoriteRestaurant(widget.restaurantId);
  }

  void handleFavoriteActionClick(RestaurantDetailProvider provider) {
    if (provider.isFavorited) {
      provider.deleteFavoriteRestaurant();
    } else {
      provider.saveFavoriteRestaurant();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => _provider,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text(
            "Detail Restaurant",
            style: TextStyle(color: Colors.white),
          ),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Builder(
              builder: (context) {
                return Consumer<RestaurantDetailProvider>(
                  builder: (context, value, _) {
                    return GestureDetector(
                      onTap: () {
                        handleFavoriteActionClick(
                            Provider.of<RestaurantDetailProvider>(context,
                                listen: false));
                      },
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Icon(Provider.of<RestaurantDetailProvider>(
                                      context,
                                      listen: false)
                                  .isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border)),
                    );
                  },
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Consumer<RestaurantDetailProvider>(
            builder: (context, value, _) {
              if (value.state == ResultState.Loading) {
                return Center(child: LinearProgressIndicator());
              } else if (value.state == ResultState.NoData) {
                return Container(child: Text(value.message));
              } else if (value.state == ResultState.HasData) {
                var restaurant = value.result;

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(35),
                                bottomRight: Radius.circular(35)),
                            child: Image.network(
                              ApiService.getImagePath(restaurant.pictureId),
                              fit: BoxFit.fitWidth,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, size: 15),
                          SizedBox(width: 5),
                          Center(
                            child: Text(
                              restaurant.city,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          restaurant.description,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "List Menu",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: restaurant.menus.foods.length - 1,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, pos) {
                            var food = pos < restaurant.menus.foods.length
                                ? restaurant.menus.foods[pos].name
                                : "";
                            var drink = pos < restaurant.menus.drinks.length
                                ? restaurant.menus.drinks[pos].name
                                : "";

                            return MenuCardItem(
                              id: restaurant.pictureId,
                              foodName: food,
                              drinkName: drink,
                            );
                          },
                        ),
                      )
                    ]);
              } else {
                return Center(child: Text(value.message));
              }
            },
          ),
        ),
      ),
    );
  }
}

class MenuCardItem extends StatelessWidget {
  final String id;
  final String foodName;
  final String drinkName;

  const MenuCardItem({
    Key key,
    this.id,
    this.foodName,
    this.drinkName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                ApiService.getImagePath(id),
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            foodName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            drinkName,
            style: TextStyle(fontSize: 12, color: Colors.black),
          )
        ],
      ),
    );
  }
}
