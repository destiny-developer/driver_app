import 'package:deliveryboy/src/repository/settings_repository.dart' as settingRepo;
import 'package:deliveryboy/src/repository/user_repository.dart' as userRepo;
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class Controller extends StateXController {
  late GlobalKey<ScaffoldState> scaffoldKey;

  Controller() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    super.initState();
    settingRepo.initSettings().then((setting) => setState(() => settingRepo.setting.value = setting));
    userRepo.getCurrentUser().then((user) => setState(() => userRepo.currentUser.value = user));
  }
}
