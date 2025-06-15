import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/controllers/profile_controller.dart';
import 'package:deliveryboy/src/elements/CircularLoadingWidget.dart';
import 'package:deliveryboy/src/elements/OrderItemWidget.dart';
import 'package:deliveryboy/src/elements/ProfileAvatarWidget.dart';
import 'package:deliveryboy/src/elements/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  ProfileWidget({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends AppStateX<ProfileWidget> {
  ProfileController? _con;

  _ProfileWidgetState() : super(controller: ProfileController()) {
    _con = controller as ProfileController?;
  }

  @override
  void initState() {
    _con?.listenForRecentOrders(message: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.sort, color: Theme.of(context).primaryColor),
          onPressed: () => widget.parentScaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).shadowColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).profile,
          style: Theme.of(context).textTheme.headlineSmall?.merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[ShoppingCartButtonWidget(iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).hintColor)],
      ),
      key: _con?.scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _con?.user != null ? ProfileAvatarWidget(user: _con!.user) : SizedBox(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(Icons.person, color: Theme.of(context).hintColor),
              title: Text(S.of(context).about, style: Theme.of(context).textTheme.headlineMedium),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _con?.user != null && _con?.user.bio != null ? Text(_con!.user.bio!, style: Theme.of(context).textTheme.bodyMedium) : SizedBox(),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(Icons.shopping_basket, color: Theme.of(context).hintColor),
              title: Text(S.of(context).recent_orders, style: Theme.of(context).textTheme.headlineMedium),
            ),
            _con!.recentOrders.isEmpty
                ? CircularLoadingWidget(height: 200)
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con!.recentOrders.length,
                    itemBuilder: (context, index) => OrderItemWidget(expanded: index == 0 ? true : false, order: _con!.recentOrders.elementAt(index)),
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                  ),
          ],
        ),
      ),
    );
  }
}
