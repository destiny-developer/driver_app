import 'dart:async';
import 'dart:convert';

import 'package:deliveryboy/src/models/Step.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapsUtil {
  static const BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?";

  static MapsUtil _instance = new MapsUtil.internal();

  MapsUtil.internal();

  factory MapsUtil() => _instance;
  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(Uri.parse(BASE_URL + url)).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        res = "{\"status\":" + statusCode.toString() + ",\"message\":\"error\",\"response\":" + res + "}";
        throw new Exception(res);
      }

      List<LatLng?> steps;
      try {
        steps = parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);
      } catch (e) {
        throw new Exception("An error occurred while parsing data");
      }
      return steps;
    });
  }

  List<LatLng?> parseSteps(final responseBody) {
    List<Step> _steps = responseBody.map<Step>((json) => Step.fromJson(json)).toList();
    List<LatLng?> _latLang = _steps.map((Step step) => step.startLatLng).toList();
    return _latLang;
  }
}
