import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/order.dart';
import 'package:deliveryboy/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'FoodOrderItemWidget.dart';

class OrderItemWidget extends StatefulWidget {
  final bool expanded;
  final Order order;

  OrderItemWidget({Key? key, required this.expanded, required this.order}) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 14),
              padding: EdgeInsets.only(top: 20, bottom: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.9),
                boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withValues(alpha: 0.1), blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: Theme(
                data: theme,
                child: ExpansionTile(
                  initiallyExpanded: widget.expanded,
                  title: Column(
                    children: <Widget>[
                      Text('${S.of(context).order_id}: #${widget.order.id}'),
                      Text(DateFormat('dd-MM-yyyy | HH:mm').format(widget.order.dateTime!), style: Theme.of(context).textTheme.bodySmall),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Helper.getPrice(Helper.getTotalOrdersPrice(widget.order), context, style: Theme.of(context).textTheme.headlineMedium!),
                      Text('${widget.order.payment?.method}', style: Theme.of(context).textTheme.bodySmall)
                    ],
                  ),
                  children: <Widget>[
                    Column(
                      children: List.generate(
                        widget.order.foodOrders.length,
                        (indexFood) {
                          return FoodOrderItemWidget(
                            heroTag: 'mywidget.orders',
                            order: widget.order,
                            foodOrder: widget.order.foodOrders.elementAt(indexFood),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(child: Text(S.of(context).delivery_fee, style: Theme.of(context).textTheme.bodyLarge)),
                              Helper.getPrice(widget.order.deliveryFee, context, style: Theme.of(context).textTheme.titleMedium!)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text('${S.of(context).tax} (${widget.order.tax}%)', style: Theme.of(context).textTheme.bodyLarge)),
                              Helper.getPrice(Helper.getTaxOrder(widget.order), context, style: Theme.of(context).textTheme.titleMedium!)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text(S.of(context).total, style: Theme.of(context).textTheme.bodyLarge)),
                              Helper.getPrice(Helper.getTotalOrdersPrice(widget.order), context, style: Theme.of(context).textTheme.headlineMedium!)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Wrap(
                alignment: WrapAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    elevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    onPressed: () => Navigator.of(context).pushNamed('/OrderDetails', arguments: RouteArgument(id: widget.order.id)),
                    textColor: Theme.of(context).hintColor,
                    child: Wrap(children: <Widget>[Text(S.of(context).viewDetails), Icon(Icons.keyboard_arrow_right)]),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 140,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).shadowColor),
          alignment: AlignmentDirectional.center,
          child: Text(
            '${widget.order.orderStatus!.status!}',
            maxLines: 1,
            style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(height: 1, color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }
}
