import 'package:deliveryboy/src/helpers/custom_trace.dart';

class Notification {
  String? id;
  String? type;
  Map<String, dynamic>? data;
  bool read = false;
  DateTime? createdAt;

  Notification();

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      type = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
      data = jsonMap['data'] != null ? {} : {};
      read = jsonMap['read_at'] != null ? true : false;
      createdAt = DateTime.parse(jsonMap['created_at']);
    } catch (e) {
      id = '';
      type = '';
      data = {};
      read = false;
      createdAt = new DateTime(0);
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }
}
