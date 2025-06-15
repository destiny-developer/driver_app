import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/elements/CircularLoadingWidget.dart';
import 'package:deliveryboy/src/elements/DrawerWidget.dart';
import 'package:deliveryboy/src/elements/FaqItemWidget.dart';
import 'package:deliveryboy/src/elements/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import 'package:deliveryboy/src/controllers/faq_controller.dart';

class HelpWidget extends StatefulWidget {
  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends AppStateX<HelpWidget> {
  FaqController? _con;

  _HelpWidgetState() : super(controller: FaqController()) {
    _con = controller as FaqController;
  }

  @override
  Widget build(BuildContext context) {
    return _con!.faqs.isEmpty
        ? Scaffold(body: CircularLoadingWidget(height: 500))
        : DefaultTabController(
            length: _con!.faqs.length,
            child: Scaffold(
              key: _con!.scaffoldKey,
              drawer: DrawerWidget(),
              appBar: AppBar(
                backgroundColor: Theme.of(context).focusColor,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                bottom: TabBar(
                  tabs: List.generate(_con!.faqs.length, (index) => Tab(text: _con!.faqs.elementAt(index).name ?? '')),
                  labelColor: Theme.of(context).primaryColor,
                ),
                title: Text(
                  S.of(context).faq,
                  style: Theme.of(context).textTheme.headlineSmall?.merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
                ),
                actions: <Widget>[ShoppingCartButtonWidget(iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).shadowColor)],
              ),
              body: RefreshIndicator(
                onRefresh: _con!.refreshFaqs,
                child: TabBarView(
                  children: List.generate(_con!.faqs.length, (index) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(height: 15),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(Icons.help, color: Theme.of(context).hintColor),
                            title: Text(
                              S.of(context).help_supports,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con!.faqs.elementAt(index).faqs!.length,
                            separatorBuilder: (context, index) => SizedBox(height: 15),
                            itemBuilder: (context, indexFaq) => FaqItemWidget(faq: _con!.faqs.elementAt(index).faqs!.elementAt(indexFaq)),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
  }
}
