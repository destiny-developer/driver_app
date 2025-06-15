import 'package:deliveryboy/src/helpers/custom_trace.dart';
import 'package:deliveryboy/src/models/extra.dart';
import 'package:deliveryboy/src/models/food.dart';

class Cart {
  String? id;
  Food? food;
  double quantity = 0.0;
  List<Extra> extras = [];
  String? userId;

  Cart();

  Cart.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
      food = jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : new Food();
      extras = jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => Extra.fromJSON(element)).toList() : [];
      food?.price = getFoodPrice();
    } catch (e) {
      id = '';
      quantity = 0.0;
      food = new Food();
      extras = [];
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity;
    map["food_id"] = food?.id;
    map["user_id"] = userId;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }

  double getFoodPrice() {
    double result = food?.price ?? 0;
    if (extras.isNotEmpty) for (Extra extra in extras) result += extra.price ?? 0;
    return result;
  }

  bool isSame(Cart cart) {
    bool _same = true;
    _same &= this.food == cart.food;
    _same &= this.extras.length == cart.extras.length;
    if (_same) this.extras.forEach((Extra _extra) => _same &= cart.extras.contains(_extra));
    return _same;
  }

  @override
  bool operator ==(dynamic other) => other.id == this.id;

  @override
  int get hashCode => super.hashCode;
}
