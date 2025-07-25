import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/controllers/order_details_controller.dart';
import 'package:deliveryboy/src/elements/CircularLoadingWidget.dart';
import 'package:deliveryboy/src/elements/DrawerWidget.dart';
import 'package:deliveryboy/src/elements/FoodOrderItemWidget.dart';
import 'package:deliveryboy/src/elements/ShoppingCartButtonWidget.dart';
import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:state_extended/state_extended.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  OrderWidget({Key? key, required this.routeArgument}) : super(key: key);

  @override
  _OrderWidgetState createState() {
    return _OrderWidgetState();
  }
}

class _OrderWidgetState extends AppStateX<OrderWidget> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _tabIndex = 0;
  OrderDetailsController? _con;

  _OrderWidgetState() : super(controller: OrderDetailsController()) {
    _con = controller as OrderDetailsController?;
  }

  @override
  void initState() {
    _con!.listenForOrder(id: widget.routeArgument.id!, message: '');
    _tabController = TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController?.addListener(_handleTabSelection);
    super.initState();
  }

  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) setState(() => _tabIndex = _tabController!.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      drawer: DrawerWidget(),
      bottomNavigationBar: _con!.order == null
          ? Container(
              height: 193,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withValues(alpha: 0.15), offset: Offset(0, -2), blurRadius: 5.0)],
              ),
              child: SizedBox(width: MediaQuery.of(context).size.width - 40),
            )
          : Container(
              height: _con!.order!.orderStatus?.id == '5' ? 190 : 250,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withValues(alpha: 0.15), offset: Offset(0, -2), blurRadius: 5.0)],
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: Text(S.of(context).subtotal, style: Theme.of(context).textTheme.bodyLarge)),
                        Helper.getPrice(Helper.getSubTotalOrdersPrice(_con!.order!), context, style: Theme.of(context).textTheme.titleMedium!)
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text(S.of(context).delivery_fee, style: Theme.of(context).textTheme.bodyLarge)),
                        Helper.getPrice(_con!.order!.deliveryFee, context, style: Theme.of(context).textTheme.titleMedium!)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('${S.of(context).tax} (${_con!.order!.tax}%)', style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Helper.getPrice(Helper.getTaxOrder(_con!.order!), context, style: Theme.of(context).textTheme.titleMedium!)
                      ],
                    ),
                    Divider(height: 30),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text(S.of(context).total, style: Theme.of(context).textTheme.headlineSmall)),
                        Helper.getPrice(Helper.getTotalOrdersPrice(_con!.order!), context, style: Theme.of(context).textTheme.headlineSmall!)
                      ],
                    ),
                    _con!.order!.orderStatus!.id != '5' ? SizedBox(height: 20) : SizedBox(height: 0),
                    _con!.order!.orderStatus!.id != '5'
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: MaterialButton(
                              elevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(S.of(context).delivery_confirmation),
                                      content: Text(S.of(context).would_you_please_confirm_if_you_have_delivered_all_meals),
                                      actions: <Widget>[
                                        // usually buttons at the bottom of the dialog
                                        MaterialButton(
                                          elevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          child: new Text(S.of(context).confirm),
                                          onPressed: () {
                                            _con!.doDeliveredOrder(_con!.order!);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        MaterialButton(
                                          elevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          child: new Text(S.of(context).dismiss),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              padding: EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).shadowColor,
                              shape: StadiumBorder(),
                              child: Text(
                                S.of(context).delivered,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                            ),
                          )
                        : SizedBox(height: 0),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
      body: _con!.order == null
          ? CircularLoadingWidget(height: 400)
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  snap: true,
                  floating: true,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                    icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
                    onPressed: () => _con!.scaffoldKey.currentState?.openDrawer(),
                  ),
                  centerTitle: true,
                  title: Text(S.of(context).order_details, style: Theme.of(context).textTheme.headlineSmall?.merge(TextStyle(letterSpacing: 1.3))),
                  actions: <Widget>[ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).shadowColor)],
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 230,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      margin: EdgeInsets.only(top: 85, bottom: 55),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.9),
                        boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withValues(alpha: 0.1), blurRadius: 5, offset: Offset(0, 2))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        S.of(context).order_id + ": #${_con!.order!.id}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.headlineMedium,
                                      ),
                                      Text(
                                        _con!.order!.orderStatus!.status!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Text(DateFormat('yyyy-MM-dd HH:mm').format(_con!.order!.dateTime!),
                                          style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Helper.getPrice(
                                      Helper.getTotalOrdersPrice(_con!.order!),
                                      context,
                                      style: Theme.of(context).textTheme.headlineMedium!,
                                    ),
                                    Text(
                                      _con!.order!.payment?.method ?? S.of(context).cash_on_delivery,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      '${S.of(context).items}: ${_con?.order?.foodOrders.length.toString() ?? '0'}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    collapseMode: CollapseMode.pin,
                  ),
                  bottom: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                      unselectedLabelColor: Theme.of(context).shadowColor,
                      labelColor: Theme.of(context).primaryColor,
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Theme.of(context).shadowColor),
                      tabs: [
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Theme.of(context).shadowColor.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(S.of(context).ordered_foods)),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Theme.of(context).shadowColor.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Align(alignment: Alignment.center, child: Text(S.of(context).customer)),
                          ),
                        ),
                      ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Offstage(
                        offstage: 0 != _tabIndex,
                        child: ListView.separated(
                          padding: EdgeInsets.only(top: 20, bottom: 50),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con!.order!.foodOrders.length,
                          separatorBuilder: (context, index) => SizedBox(height: 15),
                          itemBuilder: (context, index) => FoodOrderItemWidget(
                            heroTag: 'my_orders',
                            order: _con!.order!,
                            foodOrder: _con!.order!.foodOrders.elementAt(index),
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: 1 != _tabIndex,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(S.of(context).fullName, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                                        Text(_con!.order!.user!.name!, style: Theme.of(context).textTheme.bodyLarge),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: MaterialButton(
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      padding: EdgeInsets.all(0),
                                      disabledColor: Theme.of(context).focusColor.withValues(alpha: 0.4),
                                      child: Icon(Icons.person, color: Theme.of(context).primaryColor, size: 24),
                                      color: Theme.of(context).shadowColor.withValues(alpha: 0.9),
                                      shape: StadiumBorder(),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          S.of(context).deliveryAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        Text(
                                          _con!.order!.deliveryAddress?.address ?? S.of(context).address_not_provided_please_call_the_client,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: MaterialButton(
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      padding: EdgeInsets.all(0),
                                      disabledColor: Theme.of(context).focusColor.withValues(alpha: 0.4),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/Pages', arguments: new RouteArgument(id: '3', param: _con!.order!));
                                      },
                                      child: Icon(Icons.directions, color: Theme.of(context).primaryColor, size: 24),
                                      color: Theme.of(context).shadowColor.withValues(alpha: 0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          S.of(context).phoneNumber,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        Text(
                                          _con!.order!.user!.phone!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: MaterialButton(
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      padding: EdgeInsets.all(0),
                                      onPressed: () => launchUrlString("tel:${_con!.order!.user!.phone}"),
                                      child: Icon(Icons.call, color: Theme.of(context).primaryColor, size: 24),
                                      color: Theme.of(context).shadowColor.withValues(alpha: 0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
