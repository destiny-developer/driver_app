import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/order.dart';
import 'package:deliveryboy/src/models/order_status.dart';
import 'package:deliveryboy/src/repository/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:state_extended/state_extended.dart';

class TrackingController extends StateXController {
  Order? order;
  late List<OrderStatus> orderStatus = <OrderStatus>[];
  late GlobalKey<ScaffoldState> scaffoldKey;

  TrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder({required String orderId, required String message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() => order = _order);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).verify_your_internet_connection)));
    }, onDone: () {
      listenForOrderStatus();
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  void listenForOrderStatus() async {
    final Stream<OrderStatus> stream = await getOrderStatus();
    stream.listen((OrderStatus _orderStatus) => setState(() => orderStatus.add(_orderStatus)), onError: (a) {}, onDone: () {});
  }

  List<Step> getTrackingSteps(BuildContext context) {
    List<Step> _orderStatusSteps = [];
    this.orderStatus.forEach((OrderStatus? _orderStatus) {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(_orderStatus!.status!, style: Theme.of(context).textTheme.labelSmall),
        subtitle: order!.orderStatus!.id! == _orderStatus.id
            ? Text('${DateFormat('HH:mm | yyyy-MM-dd').format(order!.dateTime!)}', overflow: TextOverflow.ellipsis)
            : SizedBox(height: 0),
        content: SizedBox(width: double.infinity, child: Text('${Helper.skipHtml(order!.hint!)}')),
        isActive: (int.tryParse(order!.orderStatus!.id!))! >= (int.tryParse(_orderStatus.id!))!,
      ));
    });
    return _orderStatusSteps;
  }

  Future<void> refreshOrder() async {
    order = new Order();
    listenForOrder(message: S.of(state!.context).tracking_refreshed_successfuly, orderId: '');
  }
}
