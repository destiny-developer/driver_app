import 'dart:convert';
import 'dart:io';

import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/notification.dart';
import 'package:deliveryboy/src/models/user.dart';
import 'package:deliveryboy/src/repository/user_repository.dart' as userRepo;
import 'package:flutter/material.dart' as material;
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

Future<Stream<Notification>> getNotifications() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(new Notification());
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}notifications?${_apiToken}search=notifiable_id:${_user.id}&searchFields=notifiable_id:=&orderBy=created_at&sortedBy=desc&limit=10';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  material.debugPrint('getNotifications URI: ${url}');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) => Notification.fromJSON(data));
}

Future<Notification> markAsReadNotifications(Notification notification) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Notification();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}notifications/${notification.id}?$_apiToken';
  final client = new http.Client();
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('markAsReadNotifications URI: ${url}');
  material.debugPrint('markAsReadNotifications Params: ${notification.markReadMap()}');
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(notification.markReadMap()),
  );
  print("[${response.statusCode}] NotificationRepository markAsReadNotifications");
  return Notification.fromJSON(json.decode(response.body)['data']);
}

Future<Notification> removeNotification(Notification cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Notification();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}notifications/${cart.id}?$_apiToken';
  final client = new http.Client();
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  material.debugPrint('removeNotification URI: ${url}');
  final response = await client.delete(Uri.parse(url), headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  print("[${response.statusCode}] NotificationRepository removeCart");
  return Notification.fromJSON(json.decode(response.body)['data']);
}
