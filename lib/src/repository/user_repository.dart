import 'dart:convert';
import 'dart:io';

import 'package:deliveryboy/src/helpers/custom_trace.dart';
import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/address.dart';
import 'package:deliveryboy/src/models/credit_card.dart';
import 'package:deliveryboy/src/models/user.dart';
import 'package:deliveryboy/src/repository/user_repository.dart' as userRepo;
import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<User> currentUser = new ValueNotifier(User());

Future<User> login(User user) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}login';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  debugPrint('Login URL : $url');
  debugPrint('login Params : ${json.encode(user.toMap())}');
  debugPrint('login response status code : ${response.statusCode}');
  debugPrint('login response body : ${response.body}');
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  } else {
    // print(CustomTrace(StackTrace.current, message: response.body).toString());
    debugPrint('login response status code : ${response.statusCode}');
    throw new Exception(response.body);
  }
  return currentUser.value;
}

Future<User> register(User user) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  debugPrint('register URL : $url');
  debugPrint('register Params : ${json.encode(user.toMap())}');
  debugPrint('register response status code : ${response.statusCode}');
  debugPrint('register response body : ${response.body}');
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
  return currentUser.value;
}

Future<bool> resetPassword(User user) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}send_reset_link_email';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  debugPrint('resetPassword URL : $url');
  debugPrint('resetPassword Params : ${json.encode(user.toMap())}');
  debugPrint('resetPassword response status code : ${response.statusCode}');
  debugPrint('resetPassword response body : ${response.body}');
  if (response.statusCode == 200) {
    return true;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<void> logout() async {
  currentUser.value = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  try {
    if (json.decode(jsonString)['data'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(json.decode(jsonString)['data']));
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: jsonString).toString());
    throw new Exception(e);
  }
}

Future<void> setCreditCard(CreditCard creditCard) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('credit_card', json.encode(creditCard.toMap()));
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
    String? currentUserJson = prefs.getString('current_user');
    if (currentUserJson != null) {
      currentUser.value = User.fromJSON(json.decode(currentUserJson));
      currentUser.value.auth = true;
    } else {
      currentUser.value.auth = false;
    }
  } else {
    currentUser.value.auth = false;
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value;
}

Future<CreditCard> getCreditCard() async {
  CreditCard _creditCard = new CreditCard();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('credit_card')) {
    String? creditCardJson = prefs.getString('credit_card');
    if (creditCardJson != null) {
      _creditCard = CreditCard.fromJSON(json.decode(creditCardJson));
    }
  }
  return _creditCard;
}

Future<User> update(User user) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}users/${currentUser.value.id}?$_apiToken';
  final client = new http.Client();

  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  /**
   * LOC: print the URL to the console
   * BY: Ayush Agarwal ON 12-july-2024
   */
  debugPrint('update URL : $url');
  debugPrint('update Params : ${json.encode(user.toMap())}');
  debugPrint('update response status code : ${response.statusCode}');
  debugPrint('update response body : ${response.body}');
  setCurrentUser(response.body);
  currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  return currentUser.value;
}

Future<Stream<Address>> getAddresses() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=is_default&sortedBy=desc';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    /**
     * LOC: print the URL to the console
     * BY: Ayush Agarwal ON 12-july-2024
     */
    debugPrint('getAddresses URL : $url');
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data as Map<String, dynamic>))
        .expand((data) => (data as List))
        .map((data) => Address.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Stream.value(new Address.fromJSON({}));
  }
}

Future<Address> addAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    /**
     * LOC: print the URL to the console
     * BY: Ayush Agarwal ON 12-july-2024
     */
    debugPrint('addAddress URL : $url');
    debugPrint('addAddress Params : ${json.encode(address.toMap())}');
    debugPrint('addAddress response status code : ${response.statusCode}');
    debugPrint('addAddress response body : ${response.body}');
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Address> updateAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.put(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    /**
     * LOC: print the URL to the console
     * BY: Ayush Agarwal ON 12-july-2024
     */
    debugPrint('updateAddress URL : $url');
    debugPrint('updateAddress Params : ${json.encode(address.toMap())}');
    debugPrint('updateAddress response status code : ${response.statusCode}');
    debugPrint('updateAddress response body : ${response.body}');
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Address> removeDeliveryAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    /**
     * LOC: print the URL to the console
     * BY: Ayush Agarwal ON 12-july-2024
     */
    debugPrint('removeDeliveryAddress URL : $url');
    debugPrint('removeDeliveryAddress response status code : ${response.statusCode}');
    debugPrint('removeDeliveryAddress response body : ${response.body}');
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}
