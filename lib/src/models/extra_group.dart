import 'package:deliveryboy/src/helpers/custom_trace.dart';

class ExtraGroup {
  String? id;
  String? name;

  ExtraGroup();

  ExtraGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
    } catch (e) {
      id = '';
      name = '';
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  @override
  String toString() => this.toMap().toString();

  @override
  bool operator ==(dynamic other) => other.id == this.id;

  @override
  int get hashCode => this.id.hashCode;
}
