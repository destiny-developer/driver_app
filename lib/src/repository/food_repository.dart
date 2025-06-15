import 'dart:convert';
import 'dart:io';

import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/favorite.dart';
import 'package:deliveryboy/src/models/food.dart';
import 'package:deliveryboy/src/models/user.dart';
import 'package:deliveryboy/src/repository/user_repository.dart' as userRepo;
import 'package:flutter/material.dart' as material;
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

Future<Stream<Food>> getTrendingFoods() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}foods?with=restaurant&limit=6';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('getTrendingFoods URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) => Food.fromJSON(data));
}

Future<Stream<Food>> getFood(String foodId) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}foods/$foodId?with=nutrition;restaurant;category;extras;foodReviews;foodReviews.user';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('getFood URI: ${url}');
  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data as Map<String, dynamic>)).map((data) {
    print(Food.fromJSON(data).restaurant!.toMap());
    return Food.fromJSON(data);
  });
}

Future<Stream<Food>> getFoodsByCategory(categoryId) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}foods?with=restaurant&search=category_id:$categoryId&searchFields=category_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('getFoodsByCategory URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) => Food.fromJSON(data));
}

Future<Stream<Favorite>> isFavoriteFood(String foodId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(new Favorite());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites/exist?${_apiToken}food_id=$foodId&user_id=${_user.id}';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('isFavoriteFood URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getObjectData(data as Map<String, dynamic>))
      .map((data) => Favorite.fromJSON(data));
}

Future<Stream<Favorite>> getFavorites() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(new Favorite());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}favorites?${_apiToken}with=food;user;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('getFavorites URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) => Favorite.fromJSON(data));
}

Future<Favorite> addFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  favorite.userId = _user.id;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites?$_apiToken';
  final client = new http.Client();
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('addFavorite URI: ${url}');
  material.debugPrint('addFavorite Params: ${favorite.toMap()}');
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(favorite.toMap()),
  );
  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites/${favorite.id}?$_apiToken';
  final client = new http.Client();
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('removeFavorite URI: ${url}');
  final response = await client.delete(Uri.parse(url), headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Stream<Food>> getFoodsOfRestaurant(String restaurantId) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}foods?with=restaurant&search=restaurant.id:$restaurantId&searchFields=restaurant.id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('getFoodsOfRestaurant URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) => Food.fromJSON(data));
}

Future<Stream<Food>> getTrendingFoodsOfRestaurant(String restaurantId) async {
  // TODO Trending foods only
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}foods?with=restaurant&search=restaurant.id:$restaurantId&searchFields=restaurant.id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('getTrendingFoodsOfRestaurant URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) => Food.fromJSON(data));
}

Future<Stream<Food>> getFeaturedFoodsOfRestaurant(String restaurantId) async {
  // TODO Featured foods only
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}foods?with=restaurant&search=restaurant_id:$restaurantId&searchFields=restaurant_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('getFeaturedFoodsOfRestaurant URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) => Food.fromJSON(data));
}
