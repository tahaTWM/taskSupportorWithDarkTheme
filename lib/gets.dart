import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class GetsNumbers {
  static getNotifiaction() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    var url = Uri.parse("${MyApp.url}/user/device/notification");
    final response = await http.get(
      url,
      headers: requestHeaders,
    );
    final jsonResponse = json.decode(response.body);
    if (jsonResponse["successful"] == true && jsonResponse["type"] == "ok") {
      List listOfNotifactions = jsonResponse["data"];

      return listOfNotifactions.length;
    } else {
      return 0;
    }
  }
}
