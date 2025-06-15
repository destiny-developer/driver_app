import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/cart.dart';
import 'package:deliveryboy/src/models/extra.dart';
import 'package:deliveryboy/src/models/favorite.dart';
import 'package:deliveryboy/src/models/food.dart';
import 'package:deliveryboy/src/repository/food_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class FoodController extends StateXController {
  Food? food;
  double quantity = 1;
  double total = 0;
  Cart? cart;
  Favorite? favorite;
  bool loadCart = false;
  late GlobalKey<ScaffoldState> scaffoldKey;

  FoodController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForFood({required String foodId, required String message}) async {
    final Stream<Food> stream = await getFood(foodId);
    stream.listen((Food _food) {
      setState(() => food = _food);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).verify_your_internet_connection)));
    }, onDone: () {
      calculateTotal();
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  void listenForFavorite({required String foodId}) async {
    final Stream<Favorite> stream = await isFavoriteFood(foodId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  bool isSameRestaurants(Food food) {
    if (cart != null) {
      return cart!.food?.restaurant?.id == food.restaurant?.id;
    }
    return true;
  }

  void addToFavorite(Food food) async {
    var _favorite = new Favorite();
    _favorite.food = food;
    _favorite.extras = food.extras.where((Extra _extra) {
      return _extra.checked;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() => this.favorite = value);
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text('This food was added to favorite')));
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() => this.favorite = new Favorite());
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text('This food was removed from favorites')));
    });
  }

  Future<void> refreshFood() async {
    var _id = food?.id;
    food = new Food();
    listenForFavorite(foodId: _id!);
    listenForFood(foodId: _id, message: 'Food refreshed successfuly');
  }

  void calculateTotal() {
    total = food?.price ?? 0;
    food?.extras.forEach((extra) => total += extra.checked ? extra.price! : 0);
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
