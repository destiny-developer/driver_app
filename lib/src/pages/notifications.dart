import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/elements/DrawerWidget.dart';
import 'package:deliveryboy/src/elements/EmptyNotificationsWidget.dart';
import 'package:deliveryboy/src/elements/NotificationItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import 'package:deliveryboy/src/controllers/notification_controller.dart';

class NotificationsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  NotificationsWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends AppStateX<NotificationsWidget> {
  NotificationController? _con;

  _NotificationsWidgetState() : super(controller: NotificationController()) {
    _con = controller as NotificationController?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con!.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con!.scaffoldKey.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).notifications,
          style: Theme.of(context).textTheme.headlineSmall?.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            onPressed: () => Navigator.of(context).pushNamed('/Notifications'),
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: <Widget>[
                Icon(Icons.notifications_none, color: Theme.of(context).hintColor, size: 28),
                Container(
                  child: Text(
                    _con!.unReadNotificationsCount.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.merge(TextStyle(color: Theme.of(context).primaryColor, fontSize: 8)),
                  ),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                  constraints: BoxConstraints(minWidth: 13, maxWidth: 13, minHeight: 13, maxHeight: 13),
                ),
              ],
            ),
            color: Colors.transparent,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con!.refreshNotifications,
        child: _con!.notifications.isEmpty
            ? EmptyNotificationsWidget()
            : ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(Icons.notifications, color: Theme.of(context).hintColor),
                      title: Text(
                        S.of(context).notifications,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      subtitle: Text(
                        S.of(context).swip_left_the_notification_to_delete_or_read__unread,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con!.notifications.length,
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      return NotificationItemWidget(
                        notification: _con!.notifications.elementAt(index),
                        onMarkAsRead: () => _con!.doMarkAsReadNotifications(_con!.notifications.elementAt(index)),
                        onMarkAsUnRead: () => _con!.doMarkAsUnReadNotifications(_con!.notifications.elementAt(index)),
                        onRemoved: () => _con!.doRemoveNotification(_con!.notifications.elementAt(index)),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
