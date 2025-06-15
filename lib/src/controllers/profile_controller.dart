import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/order.dart';
import 'package:deliveryboy/src/models/user.dart';
import 'package:deliveryboy/src/repository/order_repository.dart';
import 'package:deliveryboy/src/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class ProfileController extends StateXController {
  User user = new User();
  List<Order> recentOrders = [];
  late GlobalKey<ScaffoldState> scaffoldKey;

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForUser();
  }

  void listenForUser() {
    getCurrentUser().then((_user) => setState(() => user = _user));
  }

  void listenForRecentOrders({required String message}) async {
    final Stream<Order> stream = await getRecentOrders();
    stream.listen((Order _order) {
      setState(() => recentOrders.add(_order));
    }, onError: (a) {
      debugPrint(a.toString());
    }, onDone: () {
      debugPrint('Ge');
    });
  }

  Future<void> refreshProfile() async {
    recentOrders.clear();
    user = new User();
    listenForRecentOrders(message: S.of(state!.context).orders_refreshed_successfuly);
    listenForUser();
  }
}
