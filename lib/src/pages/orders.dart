import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/controllers/order_controller.dart';
import 'package:deliveryboy/src/elements/EmptyOrdersWidget.dart';
import 'package:deliveryboy/src/elements/OrderItemWidget.dart';
import 'package:deliveryboy/src/elements/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  OrdersWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends AppStateX<OrdersWidget> {
  OrderController? _con;

  _OrdersWidgetState() : super(controller: OrderController()) {
    _con = controller as OrderController?;
  }

  @override
  void initState() {
    _con!.listenForOrders(message: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey!.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(S.of(context).orders, style: Theme.of(context).textTheme.headlineSmall?.merge(TextStyle(letterSpacing: 1.3))),
        actions: <Widget>[ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).shadowColor)],
      ),
      body: RefreshIndicator(
        onRefresh: _con!.refreshOrders,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: <Widget>[
            _con!.orders.isEmpty
                ? EmptyOrdersWidget()
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con!.orders.length,
                    itemBuilder: (context, index) {
                      var _order = _con!.orders.elementAt(index);
                      return OrderItemWidget(expanded: index == 0 ? true : false, order: _order);
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                  ),
          ],
        ),
      ),
    );
  }
}
