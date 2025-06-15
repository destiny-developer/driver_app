import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/credit_card.dart';
import 'package:deliveryboy/src/models/user.dart';
import 'package:deliveryboy/src/repository/user_repository.dart' as repository;
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class SettingsController extends StateXController {
  CreditCard? creditCard = new CreditCard();
  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<ScaffoldState> scaffoldKey;

  SettingsController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void update(User user) async {
    user.deviceToken = '';
    repository.update(user).then((value) {
      setState(() {});
      ScaffoldMessenger.of(scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(S.of(state!.context).profile_settings_updated_successfully)));
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    repository.setCreditCard(creditCard).then((value) {
      setState(() {});
      ScaffoldMessenger.of(scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(S.of(state!.context).payment_settings_updated_successfully)));
    });
  }

  void listenForUser() async {
    creditCard = await repository.getCreditCard();
    setState(() {});
  }

  Future<void> refreshSettings() async {
    creditCard = new CreditCard();
  }
}
