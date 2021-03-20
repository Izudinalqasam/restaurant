import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:submission1_fundamental/data/local/database_helper.dart';
import 'package:submission1_fundamental/data/local/local_data_source.dart';
import 'package:submission1_fundamental/data/remote/api_service.dart';
import 'package:submission1_fundamental/data/repository.dart';
import 'package:submission1_fundamental/presentation/detail/restaurant_detail_page.dart';
import 'package:submission1_fundamental/provider/restaurant_provider.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  PublishSubject<String> _queryChange = PublishSubject();

  Repository _repository = Repository(
      remoteDataSource: ApiService(),
      localDataSource: LocalDataSource(databaseHelper: DatabaseHelper()));

  void _searchRestaurant(RestaurantProvider provider) {
    _queryChange.stream
        .debounceTime(Duration(seconds: 2))
        .where((event) => event.isNotEmpty && event.toString().length > 1)
        .listen((event) {
      provider.searchQuestion(event);
    });
  }

  @override
  void dispose() {
    _queryChange.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<RestaurantProvider>(
        create: (_) => RestaurantProvider(repository: _repository),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Restaurant",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Recommendation restaurant for you",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
              Builder(
                builder: (currentContext) {
                  _searchRestaurant(Provider.of<RestaurantProvider>(
                      currentContext,
                      listen: false));
                  return TextField(
                    style: TextStyle(fontSize: 13),
                    onChanged: (value) {
                      _queryChange.add(value);
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusColor: Colors.orangeAccent,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orangeAccent)),
                        suffixIcon:
                            Icon(Icons.search, color: Colors.orangeAccent),
                        hintText: "Search by name, title"),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Consumer<RestaurantProvider>(
                  builder: (context, value, _) {
                    if (value.state == ResultState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (value.state == ResultState.Error) {
                      return Center(child: Text(value.message));
                    } else if (value.state == ResultState.NoData) {
                      return Center(child: Text(value.message));
                    } else if (value.state == ResultState.HasData) {
                      return ListView.builder(
                          itemCount: value.result.length,
                          itemBuilder: (context, pos) {
                            var restaurant = value.result[pos];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RestaurantDetailPage(
                                              restaurantId: restaurant.id,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        ApiService.getImagePath(
                                            restaurant.pictureId),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restaurant.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(restaurant.city),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(restaurant.rating.toString()),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.star_border,
                                              size: 15,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text(''),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
