import 'dart:async';

import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/helpers/custom_trace.dart';
import 'package:deliveryboy/src/repository/settings_repository.dart' as settingRepo;
import 'package:deliveryboy/src/repository/user_repository.dart' as userRepo;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:state_extended/state_extended.dart';

class SplashScreenController extends StateXController {
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  late GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  SplashScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // Should define these variables before the app loaded
    progress.value = {"Setting": 0, "User": 0};
  }

  @override
  void initState() async {
    super.initState();
    firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    settingRepo.setting.addListener(() {
      if (settingRepo.setting.value.appName != '') {
        progress.value["Setting"] = 41;
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        progress.notifyListeners();
      }
    });
    userRepo.currentUser.addListener(() {
      progress.value["User"] = 59;
      progress.notifyListeners();
    });
    try {
      await fcmOnLaunchListeners();
      await fcmOnResumeListeners();
      await fcmOnMessageListeners();
    } catch (e) {
      print(e.toString());
    }

    Timer(Duration(seconds: 20), () {
      ScaffoldMessenger.of(state!.context).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).verify_your_internet_connection),
      ));
    });
  }

  Future fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      Fluttertoast.showToast(
        msg: message!.notification!.title!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 6,
      );
    });
  }

  Future fcmOnLaunchListeners() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    String messageId = await settingRepo.getMessageId();
    try {
      if (messageId != message!.messageId) {
        await settingRepo.saveMessageId(message.messageId!);
        if (message.data['id'] == "orders") {
          settingRepo.navigatorKey.currentState?.pushReplacementNamed('/Pages', arguments: 3);
        } else if (message.data['id'] == "messages") {
          settingRepo.navigatorKey.currentState?.pushReplacementNamed('/Pages', arguments: 4);
        }
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(CustomTrace(StackTrace.current, message: message.data['id']));
      try {
        if (message.data['id'] == "orders") {
          settingRepo.navigatorKey.currentState?.pushReplacementNamed('/Pages', arguments: 3);
        } else if (message.data['id'] == "messages") {
          settingRepo.navigatorKey.currentState?.pushReplacementNamed('/Pages', arguments: 4);
        }
      } catch (e) {
        print(CustomTrace(StackTrace.current, message: e.toString()));
      }
    });
  }
}
