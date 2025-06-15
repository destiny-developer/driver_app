import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/elements/CircularLoadingWidget.dart';
import 'package:deliveryboy/src/repository/settings_repository.dart';
import 'package:deliveryboy/src/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import 'package:deliveryboy/src/controllers/profile_controller.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends AppStateX<DrawerWidget> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: currentUser.value.apiToken == null
          ? CircularLoadingWidget(height: 500)
          : ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/Pages', arguments: 0),
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                    accountName: Text(currentUser.value.name!, style: Theme.of(context).textTheme.headlineSmall),
                    accountEmail: Text(currentUser.value.email!, style: Theme.of(context).textTheme.bodySmall),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).shadowColor,
                      backgroundImage: NetworkImage(currentUser.value.image!.thumb!),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.of(context).pushNamed('/Pages', arguments: 1),
                  leading: Icon(Icons.fastfood, color: Theme.of(context).focusColor.withValues(alpha: 1)),
                  title: Text(S.of(context).orders, style: Theme.of(context).textTheme.titleMedium),
                ),
                ListTile(
                  onTap: () => Navigator.of(context).pushNamed('/Notifications'),
                  leading: Icon(Icons.notifications, color: Theme.of(context).focusColor.withValues(alpha: 1)),
                  title: Text(S.of(context).notifications, style: Theme.of(context).textTheme.titleMedium),
                ),
                ListTile(
                  onTap: () => Navigator.of(context).pushNamed('/Pages', arguments: 2),
                  leading: Icon(Icons.history, color: Theme.of(context).focusColor.withValues(alpha: 1)),
                  title: Text(S.of(context).history, style: Theme.of(context).textTheme.titleMedium),
                ),
                /**
           * BOC : Comment the code
           * Purpose : Remove the application Preferences and Help & Support from the drawer
           * BY : Ayush Agarwal ON : 09-07-2024
           */
                /*ListTile(
                  dense: true,
                  title: Text(S.of(context).application_preferences, style: Theme.of(context).textTheme.bodyMedium),
                  trailing: Icon(Icons.remove, color: Theme.of(context).focusColor.withValues(alpha: 0.3)),
                ),
                ListTile(
                  onTap: () => Navigator.of(context).pushNamed('/Help'),
                  leading: Icon(
                    Icons.help,
                    color: Theme.of(context).focusColor.withValues(alpha: 1),
                  ),
                  title: Text(S.of(context).help__support, style: Theme.of(context).textTheme.titleMedium),
                ),*/
                ListTile(
                  onTap: () => Navigator.of(context).pushNamed('/Settings'),
                  leading: Icon(Icons.settings, color: Theme.of(context).focusColor.withValues(alpha: 1)),
                  title: Text(S.of(context).settings, style: Theme.of(context).textTheme.titleMedium),
                ),
                ListTile(
                  onTap: () => Navigator.of(context).pushNamed('/Languages'),
                  leading: Icon(Icons.translate, color: Theme.of(context).focusColor.withValues(alpha: 1)),
                  title: Text(S.of(context).languages, style: Theme.of(context).textTheme.titleMedium),
                ),
                ListTile(
                  onTap: () {
                    if (Theme.of(context).brightness == Brightness.dark) {
                      setBrightness(Brightness.light);
                      setting.value.brightness.value = Brightness.light;
                    } else {
                      setting.value.brightness.value = Brightness.dark;
                      setBrightness(Brightness.dark);
                    }
                    setting.notifyListeners();
                  },
                  leading: Icon(Icons.brightness_6, color: Theme.of(context).focusColor.withValues(alpha: 1)),
                  title: Text(
                    Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListTile(
                  onTap: () => logout().then((value) => Navigator.of(context).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false)),
                  leading: Icon(Icons.exit_to_app, color: Theme.of(context).focusColor.withValues(alpha: 1)),
                  title: Text(S.of(context).log_out, style: Theme.of(context).textTheme.titleMedium),
                ),
                setting.value.enableVersion
                    ? ListTile(
                        dense: true,
                        title: Text(S.of(context).version + " " + setting.value.appVersion!, style: Theme.of(context).textTheme.bodyMedium),
                        trailing: Icon(Icons.remove, color: Theme.of(context).focusColor.withValues(alpha: 0.3)),
                      )
                    : SizedBox(),
              ],
            ),
    );
  }
}
