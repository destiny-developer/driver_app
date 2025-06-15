import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/favorite.dart';
import 'package:deliveryboy/src/repository/food_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class FavoriteController extends StateXController {
  List<Favorite> favorites = <Favorite>[];
  late GlobalKey<ScaffoldState> scaffoldKey;

  FavoriteController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFavorites(message: '');
  }

  void listenForFavorites({required String message}) async {
    final Stream<Favorite> stream = await getFavorites();
    stream.listen((Favorite _favorite) {
      setState(() => favorites.add(_favorite));
    }, onError: (a) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).verify_your_internet_connection)));
    }, onDone: () {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  Future<void> refreshFavorites() async {
    favorites.clear();
    listenForFavorites(message: 'Favorites refreshed successfuly');
  }
}
