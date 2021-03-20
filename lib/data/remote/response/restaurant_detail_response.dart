import 'package:submission1_fundamental/data/remote/response/restaurant_response.dart';

class RestaurantDetailResponse {
  bool error;
  String message;
  RestaurantDetail restaurant;

  RestaurantDetailResponse({this.error, this.message, this.restaurant});

  RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    restaurant = json['restaurant'] != null
        ? new RestaurantDetail.fromJson(json['restaurant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    return data;
  }
}

class RestaurantDetail {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Categories> categories;
  Menus menus;
  double rating;
  List<CustomerReviews> customerReviews;

  RestaurantDetail(
      {this.id,
      this.name,
      this.description,
      this.city,
      this.address,
      this.pictureId,
      this.categories,
      this.menus,
      this.rating,
      this.customerReviews});

  RestaurantDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    city = json['city'];
    address = json['address'];
    pictureId = json['pictureId'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    menus = json['menus'] != null ? new Menus.fromJson(json['menus']) : null;
    rating = json['rating'] is int ? json['rating'].toDouble() : json['rating'];
    if (json['customerReviews'] != null) {
      customerReviews = new List<CustomerReviews>();
      json['customerReviews'].forEach((v) {
        customerReviews.add(new CustomerReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['city'] = this.city;
    data['address'] = this.address;
    data['pictureId'] = this.pictureId;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.menus != null) {
      data['menus'] = this.menus.toJson();
    }
    data['rating'] = this.rating;
    if (this.customerReviews != null) {
      data['customerReviews'] =
          this.customerReviews.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Restaurants toRestaurant() {
    return Restaurants(
        id: this.id,
        name: this.name,
        description: this.description,
        pictureId: this.pictureId,
        city: this.city,
        rating: this.rating);
  }
}

class Categories {
  String name;

  Categories({this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class Menus {
  List<Goods> foods;
  List<Goods> drinks;

  Menus({this.foods, this.drinks});

  Menus.fromJson(Map<String, dynamic> json) {
    if (json['foods'] != null) {
      foods = new List<Goods>();
      json['foods'].forEach((v) {
        foods.add(new Goods.fromJson(v));
      });
    }
    if (json['drinks'] != null) {
      drinks = new List<Goods>();
      json['drinks'].forEach((v) {
        drinks.add(new Goods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foods != null) {
      data['foods'] = this.foods.map((v) => v.toJson()).toList();
    }
    if (this.drinks != null) {
      data['drinks'] = this.drinks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerReviews {
  String name;
  String review;
  String date;

  CustomerReviews({this.name, this.review, this.date});

  CustomerReviews.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    review = json['review'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['review'] = this.review;
    data['date'] = this.date;
    return data;
  }
}

class Goods {
  String name;

  Goods({this.name});

  Goods.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
