// ignore_for_file: deprecated_member_use

import 'package:app2/navBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'login/logn.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'Firebase_app', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

class MyApp extends StatefulWidget {
  static String url = "https://ur-task.com/api";
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
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification.android;
        // print('Notifiaction message title ${message.notification.title}');
        // print('Notifiaction message body ${message.notification.body}');
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // icon: android?.smallIcon,
                playSound: true,
              ),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("tapped when the app in the background");
    });
    checkForInitialMessage();
    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (RemoteMessage message) {
    //     print("the app is open ----------------");
    //     print('Notifiaction message title ${message.notification.title}');
    //     print('Notifiaction message body ${message.notification.body}');
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    return GetMaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        primaryColorBrightness: Brightness.light,
        brightness: Brightness.light,
        primaryColorDark: Colors.black,
        canvasColor: Colors.white,
        // accentColor: Colors.black,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.black),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.withOpacity(0.1),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark),
          elevation: 0.0,
          titleTextStyle: TextStyle(color: Colors.black),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color: Colors.black),
          ),
          // back buttom of appbar
          iconTheme: IconThemeData(color: Colors.black),
          brightness: Brightness.light,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(49, 91, 169, 1),
          textTheme: ButtonTextTheme.primary,
        ),
        buttonColor: Colors.black,
        // shadowColor: Colors.grey[300],
        iconTheme: IconThemeData(
          color: Color.fromRGBO(49, 91, 169, 1),
        ),
        dialogTheme: DialogTheme(
            contentTextStyle: TextStyle(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.grey[900],
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: Colors.black),
          headline6: TextStyle(color: Colors.black),
          subtitle2: TextStyle(color: Colors.black),
          caption: TextStyle(color: Colors.black),
          bodyText1: TextStyle(color: Colors.black),
          overline: TextStyle(color: Colors.black),
        ),
        // dividerTheme: DividerThemeData(color: Colors.black),
        dividerColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedLabelStyle:
              TextStyle(fontSize: 12, color: Colors.grey[600]),
          selectedLabelStyle:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          unselectedIconTheme: IconThemeData(size: 18, color: Colors.grey[600]),
          selectedIconTheme: IconThemeData(size: 23),
          selectedItemColor: Color.fromRGBO(49, 91, 169, 1),
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.withOpacity(0.1),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.grey[700].withOpacity(0.1),
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(26, 189, 196, 1),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(26, 189, 196, 1),
        ),
        // dividerTheme: DividerThemeData(color: Colors.white),
        dividerColor: Colors.white,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.grey[900],
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedLabelStyle: TextStyle(fontSize: 12),
          selectedLabelStyle:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          unselectedIconTheme: IconThemeData(size: 18),
          selectedIconTheme: IconThemeData(size: 23),
          selectedItemColor: Color.fromRGBO(26, 189, 196, 1),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(26, 189, 196, 1),
          foregroundColor: Colors.black,
        ),
      ),
      home: tokenFound ? NavBar(0) : Logn(),
      debugShowCheckedModeBanner: false,
    );
  }

  _getTheme() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    MyApp.mode = _pref.getBool("mode");
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

  checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

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

  _getAllCoockies() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    List keys = _pref.getKeys().toList();
    keys.forEach((element) {
      print(element.toString() + "  " + _pref.get(element).toString());
    });
  }

  _changeRoute(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => NavBar(1)));

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("tapped when the app is teminated");
    }
  }
}
