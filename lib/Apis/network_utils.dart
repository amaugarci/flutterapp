import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/globals.dart';

class NetworkUtils {
  static const String api_url = Globals.base_url + '/api/';

  static const String login = 'login';
  static const String register = 'register';
  static const String updateprofile = 'updateprofile';
  static const String checkemail = 'checkemail';
  static const String checkmobile = 'checkmobile';
  static const String changepassword = 'changepassword';
  static const String wallet = 'wallet';
  static const String addmoneytowallet = 'addmoneytowallet';
  static const String usersearch = 'usersearch';
  static const String addtransaction = 'addtransaction';
  static const String bankdetails = 'bankdetails';
  static const String addbank = 'addbank';
  static const String withdrawrequest = 'withdrawrequest';
  static const String pendingrequest = 'pendingrequest';
  static const String cancelrequest = 'cancelrequest';
  static const String acceptrequest = 'acceptrequest';
  static const String forgotpassword = 'forgotpassword';
  static const String addcomment = 'addcomment';
  static const String addlike = 'addlike';
  static const String transactionshistory = 'transactionshistory';
  static const String mytransactionshistory = 'mytransactionshistory';
  static const String faq = 'faq';
  static const String mynotification = 'mynotification';
  static const String stripepay = 'stripepay';
  static const String currenttime = 'currenttime';
  static const String carddetails = 'carddetails';
  static const String deletebank = 'deletebank';
  static const String deletecard = 'deletecard';
  static const String idverify = 'id_verify';
  static const String usercheck = 'user';

  static NetworkUtils _instance = new NetworkUtils.internal();

  NetworkUtils.internal();

  factory NetworkUtils() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> post(String url, {body, encoding}) async {
    String token = PreferencesManager.getString(StringMessage.token);

    Map<String, String> headers;
    if (token != null) {
      headers = {"Accept": "application/json", "Authorization": "Bearer " + token};
    } else {
      headers = {
        "Accept": "application/json",
      };
    }

    print("URL: " + url);
    print("Body: " + body.toString());

    return http.post(Uri.parse(url), body: body, headers: headers, encoding: encoding).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 401 || json == null) {
        throw new Exception(statusCode);
      }
      try {
        return _decoder.convert(res);
      } catch (e) {
        throw new Exception("Couldn't Refresh Feed");
      }
    }).timeout(const Duration(seconds: 300));
  }

  Future<dynamic> get(String url) async {
    String token = PreferencesManager.getString(StringMessage.token);

    Map<String, String> headers;
    if (token != null) {
      headers = {"Accept": "application/json", "Authorization": "Bearer " + token};
    } else {
      headers = {
        "Accept": "application/json",
      };
    }

    print("URL: " + url);

    return http.get(Uri.parse(url), headers: headers).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 401 || json == null) {
        throw new Exception(statusCode);
      }
      return _decoder.convert(res);
    }).timeout(const Duration(seconds: 300));
  }
}
