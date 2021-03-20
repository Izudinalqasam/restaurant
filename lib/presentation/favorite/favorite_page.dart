import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission1_fundamental/data/local/database_helper.dart';
import 'package:submission1_fundamental/data/local/local_data_source.dart';
import 'package:submission1_fundamental/data/remote/api_service.dart';
import 'package:submission1_fundamental/data/repository.dart';
import 'package:submission1_fundamental/presentation/detail/restaurant_detail_page.dart';
import 'package:submission1_fundamental/provider/favorite_provider.dart';
import 'package:submission1_fundamental/provider/restaurant_provider.dart';

class FavoritePage extends StatelessWidget {
   final Repository _repository = Repository(
      remoteDataSource: ApiService(),
      localDataSource: LocalDataSource(databaseHelper: DatabaseHelper()));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<FavoriteProvider>(
        create: (_) => FavoriteProvider(repository: _repository),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Favorite",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Your Favorite Restaurant",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Consumer<FavoriteProvider>(
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
