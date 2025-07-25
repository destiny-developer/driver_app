import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/faq.dart';
import 'package:flutter/material.dart';

class FaqItemWidget extends StatelessWidget {
  final Faq faq;

  FaqItemWidget({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Theme.of(context).focusColor.withValues(alpha: 0.15), offset: Offset(0, 5), blurRadius: 15),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: Text(
              Helper.skipHtml(this.faq.question!),
              style: Theme.of(context).textTheme.bodyLarge?.merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
            ),
            child: Text(Helper.skipHtml(this.faq.answer!), style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
