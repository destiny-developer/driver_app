import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/order.dart';
import 'package:deliveryboy/src/repository/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class OrderController extends StateXController {
  List<Order> orders = <Order>[];
  late GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrders({required String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() => orders.add(_order));
    }, onError: (a) {
      debugPrint('Error in listenForOrders: ${a.toString()}');
    }, onDone: () {
      if (message.isNotEmpty) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
      }
    });
  }

  void listenForOrdersHistory({required String message}) async {
    final Stream<Order> stream = await getOrdersHistory();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).verify_your_internet_connection)));
    }, onDone: () {
      if (message.isNotEmpty) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
      }
    });
  }

  Future<void> refreshOrdersHistory() async {
    orders.clear();
    listenForOrdersHistory(message: S.of(state!.context).order_refreshed_successfuly);
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: S.of(state!.context).order_refreshed_successfuly);
  }
}
