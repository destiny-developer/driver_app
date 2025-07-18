import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/user.dart';
import 'package:deliveryboy/src/repository/user_repository.dart' as repository;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class UserController extends StateXController {
  User? user = new User();
  bool hidePassword = true;
  bool loading = false;
  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging? _firebaseMessaging;
  OverlayEntry? loader;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging!.getToken().then((String? _deviceToken) => user!.deviceToken = _deviceToken!).catchError((e) {
      print('Notification not configured');
    });
  }

  void login() async {
    loader = Helper.overlayLoader(state!.context);
    FocusScope.of(state!.context).unfocus();
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      Overlay.of(state!.context).insert(loader!);
      repository.login(user!).then((value) => Navigator.of(scaffoldKey.currentContext!).pushReplacementNamed('/Pages', arguments: 1)).catchError((e) {
        loader?.remove();
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).thisAccountNotExist)));
      }).whenComplete(() => Helper.hideLoader(loader!));
    }
  }

  void register() async {
    loader = Helper.overlayLoader(state!.context);
    FocusScope.of(state!.context).unfocus();
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      Overlay.of(state!.context).insert(loader!);
      repository
          .register(user!)
          .then((value) => Navigator.of(scaffoldKey.currentContext!).pushReplacementNamed('/Pages', arguments: 1))
          .catchError((e) {
        loader?.remove();
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).thisAccountNotExist)));
      }).whenComplete(() => Helper.hideLoader(loader!));
    }
  }

  void resetPassword() {
    loader = Helper.overlayLoader(state!.context);
    FocusScope.of(state!.context).unfocus();
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      Overlay.of(state!.context).insert(loader!);
      repository.resetPassword(user!).then((value) {
        if (value == true) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
            content: Text(S.of(state!.context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(state!.context).login,
              onPressed: () => Navigator.of(scaffoldKey.currentContext!).pushReplacementNamed('/Login'),
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader?.remove();
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).error_verify_email_settings)));
        }
      }).whenComplete(() => Helper.hideLoader(loader!));
    }
  }
}
