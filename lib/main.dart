import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'login/logn.dart';
import 'navBar.dart';

void main() {
  // SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // lan ip
  // static String url = "http://192.168.1.2:100";

  //nogrok ip
  static String url = "https://strange-earwig-28.loca.lt";

  //wifi ip
  // static String url = "http://192.168.1.106:100";

  static bool mode = false;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var fName = "No one";
  bool tokenFound = false;

  @override
  void initState() {
    _getTheme();
    checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        primaryColorBrightness: Brightness.light,
        brightness: Brightness.light,
        primaryColorDark: Colors.black,
        canvasColor: Colors.white,

        accentColor: Colors.white,

        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.black),
        ),

        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.black),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color: Colors.black),
          ),
          // back buttom of appbar
          iconTheme: IconThemeData(color: Colors.black),
          brightness: Brightness.light,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.white),
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(22, 208, 204, 1),
          textTheme: ButtonTextTheme.normal,
        ),

        buttonColor: Colors.black,
        // shadowColor: Colors.grey[300],
        iconTheme: IconThemeData(
          color: Color.fromRGBO(22, 208, 204, 1),
        ),

        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: Colors.black),
          headline6: TextStyle(color: Colors.black),
          subtitle2: TextStyle(color: Colors.black),
          caption: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(color: Color.fromRGBO(22, 208, 204, 1)),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(22, 208, 204, 1),
        ),
      ),
      home: tokenFound == true ? NavBar(fName) : Logn(),
      debugShowCheckedModeBanner: false,
    );
  }

  checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    if (token == null) {
      setState(() {
        tokenFound = false;
      });
    }
    if (token != null) {
      List list;
      list = pref.getStringList("firstSecond") ?? null;
      fName = list[0].toString();
      setState(() {
        tokenFound = true;
        fName = list[0].toString();
      });
    }
  }

  _getTheme() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    MyApp.mode = await _pref.getBool("mode");
    if (MyApp.mode != null) {
      setState(() {
        MyApp.mode
            ? Get.changeThemeMode(ThemeMode.dark)
            : Get.changeThemeMode(ThemeMode.light);
      });
    } else {
      setState(() {
        MyApp.mode = false;
      });
    }
  }
}
