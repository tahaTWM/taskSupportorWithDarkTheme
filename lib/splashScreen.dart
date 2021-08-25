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

  initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        child: Lottie.network(
            "https://assets4.lottiefiles.com/packages/lf20_lQfkLu.json"),
      ),
      nextScreen: tokenFound == true ? NavBar(fName) : Logn(),

      splashIconSize: MediaQuery.of(context).size.width > 400 ? 600 : 400,
      duration: 6500,
      // pageTransitionType: PageTransitionType.rightToLeft,
      centered: true,
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
}
