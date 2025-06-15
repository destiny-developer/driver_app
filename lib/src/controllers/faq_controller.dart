import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/models/faq_category.dart';
import 'package:deliveryboy/src/repository/faq_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class FaqController extends StateXController {
  List<FaqCategory> faqs = <FaqCategory>[];
  late GlobalKey<ScaffoldState> scaffoldKey;

  FaqController() {
    scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFaqs(message: '');
  }

  void listenForFaqs({required String message}) async {
    final Stream<FaqCategory> stream = await getFaqCategories();
    stream.listen((FaqCategory _faq) {
      setState(() => faqs.add(_faq));
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(S.of(state!.context).verify_your_internet_connection)));
    }, onDone: () {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  Future<void> refreshFaqs() async {
    faqs.clear();
    listenForFaqs(message: 'Faqs refreshed successfuly');
  }
}
