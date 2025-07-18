import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/food.dart';
import 'package:deliveryboy/src/models/gallery.dart';
import 'package:deliveryboy/src/models/restaurant.dart';
import 'package:deliveryboy/src/models/review.dart';
import 'package:deliveryboy/src/repository/food_repository.dart';
import 'package:deliveryboy/src/repository/gallery_repository.dart';
import 'package:deliveryboy/src/repository/restaurant_repository.dart';
import 'package:deliveryboy/src/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class RestaurantController extends StateXController {
  Restaurant? restaurant;
  List<Gallery> galleries = <Gallery>[];
  List<Food> foods = <Food>[];
  List<Food> trendingFoods = <Food>[];
  List<Food> featuredFoods = <Food>[];
  List<Review> reviews = <Review>[];
  late GlobalKey<ScaffoldState> scaffoldKey;

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForRestaurant({required String id, required String message}) async {
    final Stream<Restaurant> stream = await getRestaurant(id, myAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => restaurant = _restaurant);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).verify_your_internet_connection)));
    }, onDone: () {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  void listenForGalleries(String idRestaurant) async {
    final Stream<Gallery> stream = await getGalleries(idRestaurant);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForRestaurantReviews({required String id, required String message}) async {
    final Stream<Review> stream = await getRestaurantReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForFoods(String idRestaurant) async {
    final Stream<Food> stream = await getFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => foods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForTrendingFoods(String idRestaurant) async {
    final Stream<Food> stream = await getTrendingFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedFoods(String idRestaurant) async {
    final Stream<Food> stream = await getFeaturedFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => featuredFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshRestaurant() async {
    var _id = restaurant!.id;
    restaurant = new Restaurant();
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    listenForRestaurant(id: _id!, message: S.of(state!.context).restaurant_refreshed_successfuly);
    listenForRestaurantReviews(id: _id, message: '');
    listenForGalleries(_id);
    listenForFeaturedFoods(_id);
  }
}
