import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/notification.dart' as model;
import 'package:deliveryboy/src/repository/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class NotificationController extends StateXController {
  List<model.Notification> notifications = <model.Notification>[];
  int unReadNotificationsCount = 0;
  late GlobalKey<ScaffoldState> scaffoldKey;

  NotificationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForNotifications(message: '');
  }

  void listenForNotifications({required String message}) async {
    final Stream<model.Notification> stream = await getNotifications();
    stream.listen((model.Notification _notification) {
      setState(() => notifications.add(_notification));
    }, onError: (a) {
      debugPrint('Error in listenForNotifications ${a.toString()}');
    }, onDone: () {
      if (notifications.isNotEmpty) {
        unReadNotificationsCount = notifications.where((model.Notification _n) => !_n.read).toList().length;
      } else {
        unReadNotificationsCount = 0;
      }
    });
  }

  Future<void> refreshNotifications() async {
    notifications.clear();
    listenForNotifications(message: S.of(state!.context).notifications_refreshed_successfuly);
  }

  void doMarkAsReadNotifications(model.Notification _notification) async {
    markAsReadNotifications(_notification).then((value) {
      setState(() {
        --unReadNotificationsCount;
        _notification.read = !_notification.read;
      });
    });
  }

  void doMarkAsUnReadNotifications(model.Notification _notification) {
    markAsReadNotifications(_notification).then((value) {
      setState(() {
        ++unReadNotificationsCount;
        _notification.read = !_notification.read;
      });
    });
  }

  void doRemoveNotification(model.Notification _notification) async {
    removeNotification(_notification).then((value) {
      setState(() {
        if (!_notification.read) {
          --unReadNotificationsCount;
        }
        this.notifications.remove(_notification);
      });
    });
  }
}
