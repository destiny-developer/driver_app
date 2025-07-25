import 'package:deliveryboy/src/helpers/custom_trace.dart';
import 'package:deliveryboy/src/models/media.dart';

class Gallery {
  String? id;
  Media? image;
  String? description;

  Gallery();

  Gallery.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
      description = jsonMap['description'];
    } catch (e) {
      id = '';
      image = new Media();
      description = '';
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }
}
