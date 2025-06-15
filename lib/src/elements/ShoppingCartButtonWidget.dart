import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import 'package:deliveryboy/src/controllers/notification_controller.dart';

class ShoppingCartButtonWidget extends StatefulWidget {
  const ShoppingCartButtonWidget({required this.iconColor, required this.labelColor, Key? key}) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _ShoppingCartButtonWidgetState createState() => _ShoppingCartButtonWidgetState();
}

class _ShoppingCartButtonWidgetState extends AppStateX<ShoppingCartButtonWidget> {
  late NotificationController _con;

  _ShoppingCartButtonWidgetState() : super() {
    _con = controller as NotificationController;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      onPressed: () => Navigator.of(context).pushNamed('/Notifications'),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(Icons.notifications_none, color: this.widget.iconColor, size: 28),
          Container(
            child: Text(
              _con.unReadNotificationsCount.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).primaryColor, fontSize: 8, height: 1.3)),
            ),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(color: this.widget.labelColor, borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(minWidth: 13, maxWidth: 13, minHeight: 13, maxHeight: 13),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
