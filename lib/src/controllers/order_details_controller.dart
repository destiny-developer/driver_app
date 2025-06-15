import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/order.dart';
import 'package:deliveryboy/src/repository/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class OrderDetailsController extends StateXController {
  Order? order;
  late GlobalKey<ScaffoldState> scaffoldKey;

  OrderDetailsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder({required String id, required String message}) async {
    final Stream<Order> stream = await getOrder(id);
    stream.listen((Order _order) {
      setState(() => order = _order);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).verify_your_internet_connection)));
    }, onDone: () {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(id: order!.id!, message: S.of(state!.context).order_refreshed_successfuly);
  }

  void doDeliveredOrder(Order _order) async {
    deliveredOrder(_order).then((value) {
      setState(() => this.order!.orderStatus!.id = '5');
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text('The order deliverd successfully to client')));
    });
  }
}
