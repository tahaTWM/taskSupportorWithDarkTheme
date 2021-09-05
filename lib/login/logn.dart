import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../navBar.dart';
import 'forgotPassword.dart';
import 'register.dart';

class Logn extends StatefulWidget {
  static getToken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    String token = await _firebaseMessaging.getToken();
    print(token);
  }

  @override
  State<StatefulWidget> createState() {
    return new _Logn();
  }
}

class _Logn extends State<Logn> {
  final TextEditingController _eMail = new TextEditingController();
  final TextEditingController _passWord = new TextEditingController();
  var errorMSG = "";
  bool isCheck = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  var fName = "No one";
  bool tokenFound = false;

  @override
  void initState() {
    super.initState();
    getCredential();
    // checkLoginStatus();
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String fcm = "";

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              // logo
              Padding(
                padding: EdgeInsets.only(top: w > 400 ? 50 : 20),
                child: Center(
                  child: Image(
                      width: 200,
                      height: 200,
                      image: AssetImage("asset/newLogo3.png")),
                ),
              ),
              SizedBox(height: 20),

              // enter email
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width - 20,
                child: new TextFormField(
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Rubik",
                    // color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Email"),
                  controller: _eMail,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!EmailValidator.validate(value))
                        return 'it is not email';
                    } else
                      return 'the text feild is empty';
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    _formKey.currentState.validate();
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      signIn(_eMail.text, _passWord.text);
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 20),
              // enter password
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: new TextFormField(
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Rubik",
                        // color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: new BorderSide(
                              // color: Colors.red,
                              ),
                        ),
                        hintText: "Password",
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              semanticLabel: _obscureText
                                  ? 'show password'
                                  : 'hide password',
                              // color: Color.fromRGBO(112, 112, 112, 1),
                            ),
                          ),
                        ),
                      ),
                      controller: _passWord,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (_passWord.text.length < 8)
                            return 'password should be 8 characters at less';
                        } else
                          return 'password should not be empty!';
                        return null;
                      },
                      onFieldSubmitted: (_) async {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          signIn(_eMail.text, _passWord.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // remember email and forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: GFCheckbox(
                          size: GFSize.SMALL,
                          inactiveBorderColor: Color.fromRGBO(0, 82, 204, 1),
                          activeBorderColor: Color.fromRGBO(0, 82, 204, 1),
                          inactiveBgColor: Colors.transparent,
                          activeBgColor: GFColors.WHITE,
                          type: GFCheckboxType.circle,
                          onChanged: _onChanged,
                          value: isCheck,
                          activeIcon: const Icon(
                            Icons.check,
                            size: 20,
                            // color: Color.fromRGBO(0, 82, 204, 1),
                          ),
                          inactiveIcon: null,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Remember Email",
                        style: TextStyle(
                          fontFamily: "Rubik",
                          fontSize: 18,
                          // color: Color.fromRGBO(112, 112, 112, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Login button
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async {
                    signIn(_eMail.text, _passWord.text);
                    FocusScope.of(context).requestFocus(FocusNode());
                    // Navigator.pop(context);
                  },
                  child: Text(
                    "LogIn",
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: "Rubik",
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),

              // register
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.grey[600],
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                        (route) => true);
                  },
                  child: Text(
                    "Create a free account",
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: "Rubik",
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // Toast.show(
                      //   "Toast plugin app",
                      //   context,
                      //   duration: Toast.LENGTH_SHORT,
                      //   gravity: Toast.BOTTOM,
                      //   backgroundColor: Colors.lightBlue,
                      //   textColor: Colors.black,
                      //   backgroundRadius: 20,
                      // );
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                          (route) => true);
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                          fontFamily: "Rubik",
                          fontSize: 18,
                          // color: Color.fromRGBO(112, 112, 112, 1),
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => print("tapped"),
                      child: Image(
                        image: AssetImage("asset/facebook.png"),
                        width: 55,
                        height: 55,
                      ),
                    ),
                    InkWell(
                      onTap: () => print("tapped"),
                      child: Image(
                        image: AssetImage("asset/github.png"),
                        width: 55,
                        height: 55,
                      ),
                    ),
                    InkWell(
                      onTap: () => print("tapped"),
                      child: Image(
                        image: AssetImage("asset/google.png"),
                        width: 66,
                        height: 66,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onChanged(bool value) async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    if (_eMail.text.isNotEmpty) {
      setState(() {
        isCheck = value;
        sharedPreferences.setBool("check", isCheck);
        sharedPreferences.setString("email", _eMail.text);
        getCredential();
      });
    }
  }

  getCredential() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isCheck = sharedPreferences.getBool("check");
      if (isCheck != null) {
        if (isCheck) {
          _eMail.text = sharedPreferences.getString("email");
        } else {
          _eMail.clear();
          _passWord.clear();
        }
      } else {
        isCheck = false;
      }
    });
  }

  Map<String, String> requestHeaders = {
    "Content-type": "application/json; charset=UTF-8",
  };

  signIn(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // ignore: avoid_init_to_null

    var url = Uri.parse("${MyApp.url}/user/login");
    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        <String, String>{
          "email": email,
          "password": password,
        },
      ),
    );

    var jsonResponse = json.decode(response.body);
    if (jsonResponse["successful"] == true) {
      await sharedPreferences.setString("token", jsonResponse['data']['token']);

      await sharedPreferences.setStringList('firstSecond', [
        jsonResponse['data']['firstName'],
        jsonResponse['data']['secondName'],
      ]);

      await sharedPreferences.setString(
          "userAvatar", jsonResponse['data']['user_avatar'].toString());

      await sharedPreferences.setString("email", _eMail.text);

      await sharedPreferences.setString(
          "creationDate", jsonResponse['data']["registrationDate"].toString());

      await getToken();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(0),
        ),
      );
    }

    if (!jsonResponse["successful"]) {
      showsnakbar(
        jsonResponse["type"],
        jsonResponse["message"],
      );
    }
  }

  showsnakbar(String type, String msg) {
    print(type);
    print(msg);

    var snakbar;
    if (type == null)
      snakbar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          msg.contains(',')
              ? "${msg.split(',')[0]}'\n'${msg.split(',')[1]}"
              : msg,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    else
      snakbar = SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                // color: Colors.yellow,
              ),
              SizedBox(width: 10),
              Text(
                msg.contains(',')
                    ? "${msg.split(',')[0]}'\n'${msg.split(',')[1]}"
                    : msg,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ));
    scaffoldMessengerKey.currentState.showSnackBar(snakbar);
  }

  getToken() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": _pref.getString("token"),
    };
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    if (await Permission.storage.request().isGranted) {
      String token = await _firebaseMessaging.getToken();
      var url = Uri.parse("${MyApp.url}/user/device/notification");
      var response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          <String, String>{"fcm_token": token},
        ),
      );
      var jsonResponse = json.decode(response.body);
      await _pref.setInt("fcmTokenId", jsonResponse['data']["user_device_id"]);
      // showsnakbar(
      //   jsonResponse["type"],
      //   jsonResponse["message"],
      // );
    }
  }
}
