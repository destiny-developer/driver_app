import 'dart:convert';

import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/category.dart';
import 'package:flutter/material.dart' as material;
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

Future<Stream<Category>> getCategories() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}categories';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('getCategories URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) => Category.fromJSON(data));
}

Future<Stream<Category>> getCategory(String id) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}categories/$id';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .map((data) => Category.fromJSON(data));
}
