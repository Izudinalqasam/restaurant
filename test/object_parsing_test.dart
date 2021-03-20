// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';

void main() {
  group("Parsing object to json", () {
    Restaurants restaurants;

    setUp(() {
      restaurants = Restaurants(
          id: "1",
          name: "user1",
          description: "user 1 description",
          pictureId: "123",
          city: "the city of sun",
          rating: 4.2);
    });

    test("result json has to be match with object before convert to json", () {
      // Act
      var jsonResult = restaurants.toJson();

      // Assert
      expect(restaurants.id, jsonResult["id"]);
    });
  });
}
