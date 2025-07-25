import 'package:deliveryboy/src/helpers/custom_trace.dart';
import 'package:deliveryboy/src/models/food.dart';
import 'package:deliveryboy/src/models/restaurant.dart';
import 'package:deliveryboy/src/models/user.dart';

class Review {
  String? id;
  String? review;
  String? rate;
  User? user;

  Review();

  Review.init(this.rate);

  Review.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      review = jsonMap['review'];
      rate = jsonMap['rate'].toString();
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
    } catch (e) {
      id = '';
      review = '';
      rate = '0';
      user = new User();
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["user_id"] = user?.id;
    return map;
  }

  @override
  String toString() => this.toMap().toString();

  Map ofRestaurantToMap(Restaurant restaurant) {
    var map = this.toMap();
    map["restaurant_id"] = restaurant.id;
    return map;
  }

  Map ofFoodToMap(Food food) {
    var map = this.toMap();
    map["food_id"] = food.id;
    return map;
  }

  @override
  bool operator ==(dynamic other) => other.id == this.id;

  @override
  int get hashCode => this.id.hashCode;
}
