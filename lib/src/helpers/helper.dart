import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/elements/CircularLoadingWidget.dart';
import 'package:deliveryboy/src/models/food_order.dart';
import 'package:deliveryboy/src/models/order.dart';
import 'package:deliveryboy/src/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';

class Helper {
  BuildContext? context;

  Helper.of(BuildContext _context) {
    this.context = _context;
  }

  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) => data['data'] ?? [];

  static int getIntData(Map<String, dynamic> data) => (data['data'] as int);

  static bool getBoolData(Map<String, dynamic> data) => (data['data'] as bool);

  static getObjectData(Map<String, dynamic> data) => data['data'] ?? new Map<String, dynamic>();

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  static Future<Marker> getMarker(Map<String, dynamic> res) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
      markerId: MarkerId(res['id']),
      icon: BitmapDescriptor.bytes(markerIcon),
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: res['name'], snippet: res['distance'].toStringAsFixed(2) + ' mi', onTap: () {}),
      position: LatLng(double.parse(res['latitude']), double.parse(res['longitude'])),
    );

    return marker;
  }

  static Future<Marker> getOrderMarker(Map<dynamic, dynamic> res) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
      markerId: MarkerId(res['id']),
      icon: BitmapDescriptor.bytes(markerIcon),
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: res['address'], snippet: '', onTap: () {}),
      position: LatLng(res['latitude'], res['longitude']),
    );

    return marker;
  }

  static Future<Marker> getMyPositionMarker(double latitude, double longitude) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
      markerId: MarkerId(Random().nextInt(100).toString()),
      icon: BitmapDescriptor.bytes(markerIcon),
      anchor: Offset(0.5, 0.5),
      position: LatLng(latitude, longitude),
    );

    return marker;
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) => Icon(Icons.star, size: size, color: Color(0xFFFFB24D)));
    if (rate - rate.floor() > 0) list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    list.addAll(
      List.generate(
        5 - rate.floor() - (rate - rate.floor()).ceil(),
        (index) => Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D)),
      ),
    );
    return list;
  }

  static Widget getPrice(double myPrice, BuildContext context, {required TextStyle style}) {
    style = style.merge(TextStyle(fontSize: style.fontSize! + 2));
    try {
      if (myPrice == 0) return Text('-', style: style);
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value.currencyRight == false
            ? TextSpan(
                text: setting.value.defaultCurrency,
                style: style,
                children: <TextSpan>[TextSpan(text: myPrice.toStringAsFixed(2), style: style)],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(2),
                style: style,
                children: <TextSpan>[
                  TextSpan(text: setting.value.defaultCurrency, style: TextStyle(fontWeight: FontWeight.w400, fontSize: style.fontSize! - 4)),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static double getTotalOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) => total += extra.price != null ? extra.price! : 0);
    total *= foodOrder.quantity;
    return total;
  }

  static double getOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) => total += extra.price != null ? extra.price! : 0);
    return total;
  }

  static double getTaxOrder(Order order) {
    double total = 0;
    order.foodOrders.forEach((foodOrder) => total += getTotalOrderPrice(foodOrder));
    total += order.deliveryFee;
    return order.tax * total / 100;
  }

  static double getTotalOrdersPrice(Order order) {
    double total = 0;
    order.foodOrders.forEach((foodOrder) => total += getTotalOrderPrice(foodOrder));
    total += order.deliveryFee;
    total += order.tax * total / 100;
    return total;
  }

  static double getSubTotalOrdersPrice(Order order) {
    double total = 0;
    order.foodOrders.forEach((foodOrder) => total += getTotalOrderPrice(foodOrder));
    return total;
  }

  static String getDistance(double distance, String unit) {
    String _unit = setting.value.distanceUnit!;
    if (_unit == 'km') distance *= 1.60934;
    return distance.toStringAsFixed(2) + " " + unit;
  }

  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body?.text).documentElement!.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(color: Theme.of(context).primaryColor.withValues(alpha: 0.85), child: CircularLoadingWidget(height: 200)),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader.remove();
      } catch (e) {}
    });
  }

  static String limitString(String text, {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) + (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number.isNotEmpty && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(GlobalConfiguration().getValue('base_url')).path;
    if (!_path.endsWith('/')) _path += '/';

    Uri uri = Uri(
      scheme: Uri.parse(GlobalConfiguration().getValue('base_url')).scheme,
      host: Uri.parse(GlobalConfiguration().getValue('base_url')).host,
      port: Uri.parse(GlobalConfiguration().getValue('base_url')).port,
      path: _path + path,
    );
    return uri;
  }

  String trans(String text) {
    switch (text) {
      case "App\\Notifications\\StatusChangedOrder":
        return S.of(context!).order_satatus_changed;
      case "App\\Notifications\\NewOrder":
        return S.of(context!).new_order_from_costumer;
      case "App\\Notifications\\AssignedOrder":
        return S.of(context!).your_have_an_order_assigned_to_you;
      case "km":
        return S.of(context!).km;
      case "mi":
        return S.of(context!).mi;
      default:
        return "";
    }
  }

  static bool isUuid(String input) => RegExp("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}").hasMatch(input);
}
