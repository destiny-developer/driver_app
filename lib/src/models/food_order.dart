import 'package:deliveryboy/src/helpers/custom_trace.dart';
import 'package:deliveryboy/src/models/extra.dart';
import 'package:deliveryboy/src/models/food.dart';

class FoodOrder {
  String? id;
  double price = 0.0;
  double quantity = 0.0;
  List<Extra> extras = [];
  Food? food;
  DateTime? dateTime;

  FoodOrder();

  FoodOrder.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
      food = (jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : []) as Food?;
      dateTime = DateTime.parse(jsonMap['updated_at']);
      extras = (jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => Extra.fromJSON(element)).toList() : null)!;
    } catch (e) {
      id = '';
      price = 0.0;
      quantity = 0.0;
      food = new Food();
      dateTime = DateTime(0);
      extras = [];
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["price"] = price;
    map["quantity"] = quantity;
    map["food_id"] = food?.id;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
