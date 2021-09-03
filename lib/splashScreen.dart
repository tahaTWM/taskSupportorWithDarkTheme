import 'package:app2/navBar.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/logn.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var fName = "No one";
  bool tokenFound = false;
  bool skip = false;

  initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: AnimatedSplashScreen(
              splash: Lottie.network(
                // "https://assets4.lottiefiles.com/packages/lf20_lQfkLu.json",
                "https://assets9.lottiefiles.com/packages/lf20_jy1bgnpp.json",
              ),
              nextScreen: tokenFound == true ? NavBar(0) : Logn(),
              splashIconSize:
                  MediaQuery.of(context).size.width > 400 ? 500 : 400,
              duration: 5000,
              // pageTransitionType: PageTransitionType.rightToLeft,
            ),
          ),
          CheckboxListTile(
            title: Text("Skip the Intero Next Time"),
            onChanged: (bool value) {
              setState(() {
                skip = value;
              });
              _setSkip(value);
            },
            value: skip,
          )
        ],
      ),
    );
  }

  checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    if (pref.getBool("skip") != null) {
      setState(() {
        skip = pref.getBool("skip");
      });
    }
    if (token == null) {
      setState(() {
        tokenFound = false;
      });
    } else {
      List list;
      list = pref.getStringList("firstSecond") ?? null;
      fName = list[0].toString();
      setState(() {
        tokenFound = true;
        fName = list[0].toString();
      });
    }
  }

  _setSkip(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("skip", value);
  }
}
