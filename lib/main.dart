import 'package:app2/all_tasks/showAllTasks.dart';
import 'package:app2/homePage/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'login/logn.dart';
import 'navBar.dart';

void main() {
  // SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // lan ip
  static String url = "http://192.168.1.2:100";

  //nogrok ip
  // static String url = "http://a8592df906d6.ngrok.io";

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
        accentColor: Colors.white,
        primaryColor: Colors.white,
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
        ),

        buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue, textTheme: ButtonTextTheme.primary),

        // shadowColor: Colors.grey[300],
        iconTheme: IconThemeData(color: Colors.blue),

        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          headline3: TextStyle(color: Colors.yellow),
          headline4: TextStyle(color: Colors.orange),
          headline5: TextStyle(color: Colors.pink),
          bodyText1: TextStyle(color: Colors.red),
          bodyText2: TextStyle(color: Colors.black),
          button: TextStyle(color: Colors.yellow),
          subtitle1: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark()
      // .copyWith(
      //   primaryColorLight: Colors.black,
      //   primaryColor: Colors.red,
      //   accentColor: Colors.white,
      //   // shadowColor: Colors.grey[300],
      //   textTheme: TextTheme(
      //     bodyText1: TextStyle(color: Colors.white),
      //     bodyText2: TextStyle(color: Colors.white),
      //   ),
      // )
      ,
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
