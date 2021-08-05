import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:users_post/helper/HelperFunction.dart';

class Url {
  static const String baseUrl = "https://gorest.co.in/public/v1/";
}

class ServiceApi {
  static Future api(String url, String type, BuildContext context1,
      {bool headerWithTokenBool, var body, bool showSuccessFalseMsg}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    print(Url.baseUrl + url);
    switch (type) {
      case "get":
        {
          try {
            final http.Response response = await http.get(
              Uri.parse(Url.baseUrl + url),
              headers: headers,
            );
            return checkResponse(response, context1,
                showSuccessFalseMsg: showSuccessFalseMsg);
          } on SocketException catch (e) {
            debugPrint(e.toString());
            HelperFunction.showFlushbarError(
                context1, "Please check internet connection");
            return null;
          } catch (e) {
            debugPrint(e.toString());
            HelperFunction.showFlushbarError(context1, "Something went wrong");
            return null;
          }
        }
        break;

      case "post":
        {}
        break;
      case "put":
        {}
        break;
      case "delete":
        {}
        break;
      default:
        {
          print('Wrong choice dude!!!');
        }
    }
  }

  static dynamic checkResponse(http.Response response, BuildContext context1,
      {bool showSuccessFalseMsg}) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        if (showSuccessFalseMsg != false && responseJson['success'] == false) {
          HelperFunction.showFlushbarError(
              context1, "${responseJson['message']}");
        }
        return responseJson;
      case 201:
        return null;
      case 401:
        return null;
      case 404:
        HelperFunction.showFlushbarError(context1, "Server url not found");
        return null;
      case 412:
        var responseJson = json.decode(response.body.toString());
        HelperFunction.showFlushbarError(
            context1, "${responseJson['message']}");
        return null;
      case 500:
        HelperFunction.showFlushbarError(
            context1, "Something went wrong on server");
        return null;
      default:
        throw null;
    }
  }
}
