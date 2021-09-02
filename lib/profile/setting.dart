import 'dart:io';
import 'package:app2/login/logn.dart';
import 'package:app2/navBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Setting extends StatefulWidget {
  String title;

  Setting(this.title);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isSwitched = false;
  bool notificatoins = false;
  String userAvatar;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool timeZoneSwitch = false;
  bool showAllEventSwitch = false;
  bool emailNotifSwitch = false;
  var profileName = '';
  String fName = '';
  String sName = '';
  String email = '';
  TextEditingController textEditingControllerFName = TextEditingController();
  TextEditingController textEditingControllerSName = TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerConformNewPassword =
      TextEditingController();

  TextEditingController textEditingControllerOldPassword =
      TextEditingController();
  TextEditingController textEditingControllerNewPassword =
      TextEditingController();

  File image;

  String workspaces = "0";
  String tasks = "0";
  final ImagePicker _picker = ImagePicker();
  bool skip = false;

  @override
  void initState() {
    name();
    _getthemeBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Settings",
            textAlign: TextAlign.start,
            style: TextStyle(
              wordSpacing: 3,
              // fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("test");
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55)),
                                // color: Colors.red,
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.deepOrangeAccent,
                                child:
                                    userAvatar == null || userAvatar == "null"
                                        ? Text(
                                            widget.title
                                                .toString()[0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontFamily: "RubikB"),
                                          )
                                        : ClipOval(
                                            child: Image.network(
                                              "${MyApp.url}$userAvatar",
                                              height: 55,
                                              width: 55,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              widget.title,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Account Settings',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                      Field(
                        colur: Colors.brown[900],
                        icon: Icon(
                          isSwitched ? Icons.dark_mode : Icons.light_mode,
                          color: Colors.white,
                        ),
                        txt: "  Dark Mode",
                        endd: Switch(
                          value: isSwitched,
                          inactiveTrackColor: Colors.grey,
                          activeTrackColor: Colors.greenAccent,
                          activeColor: Colors.greenAccent,
                          inactiveThumbColor: Colors.greenAccent,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              isSwitched == true
                                  ? Get.changeThemeMode(ThemeMode.dark)
                                  : Get.changeThemeMode(ThemeMode.light);

                              isSwitched == false
                                  ? _changeTheme(false)
                                  : _changeTheme(true);
                            });
                          },
                        ),
                      ),

                      Field(
                          colur: Colors.green,
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                          txt: "  Skiping Intro",
                          endd: Checkbox(
                            onChanged: (bool value) {
                              _setSkip(value);
                              setState(() {
                                skip = value;
                              });
                            },
                            value: skip,
                          )),

                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text(
                      //       'Porfile',
                      //       style: TextStyle(
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.w800,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Field(
                        onclick: () {
                          _newBottomSheetChangeUserName(context);
                        },
                        colur: Colors.orangeAccent,
                        icon: Icon(
                          Icons.emoji_people,
                          color: Colors.white,
                          size: 26,
                        ),
                        txt: "Change User Name",
                        endd: Icon(
                          Icons.keyboard_arrow_right,
                          size: 32,
                        ),
                      ),
                      Field(
                          onclick: () {
                            _newBottomSheetChangePassword(context);
                          },
                          colur: Colors.blue,
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          txt: "Change Password",
                          endd: Icon(
                            Icons.keyboard_arrow_right,
                            size: 32,
                          )),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text(
                      //       'Notificatoins',
                      //       style: TextStyle(
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.w800,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Field(
                      //   onclick: () {},
                      //   colur: Colors.green,
                      //   icon: Icon(
                      //     Icons.notifications,
                      //     color: Colors.white,
                      //     size: 28,
                      //   ),
                      //   txt: "  Notificatoins",
                      //   endd: Switch(
                      //     value: notificatoins,
                      //     inactiveTrackColor: Colors.grey,
                      //     activeTrackColor: Colors.greenAccent,
                      //     activeColor: Colors.greenAccent,
                      //     inactiveThumbColor: Colors.greenAccent,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         notificatoins = value;
                      //         print(notificatoins);
                      //       });
                      //     },
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text(
                      //       'Regional',
                      //       style: TextStyle(
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.w800,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Field(
                      //   onclick: () {},
                      //   colur: Colors.purple,
                      //   icon: Icon(
                      //     Icons.language,
                      //     color: Colors.white,
                      //     size: 26,
                      //   ),
                      //   txt: "Language",
                      //   endd: Icon(
                      //     Icons.keyboard_arrow_right,
                      //     size: 32,
                      //   ),
                      // ),
                      Field(
                        onclick: () async {
                          _siginOut();
                        },
                        colur: Colors.orange[900],
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 28,
                        ),
                        txt: "Logout",
                        endd: Icon(
                          Icons.keyboard_arrow_right,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Alph version 0.0.1",
                    style: TextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changeTheme(bool mode) async {
    print("mode : " + mode.toString());
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setBool("mode", mode);
  }

  _getthemeBool() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = _pref.getBool("mode") ?? false;
      userAvatar = _pref.getString("userAvatar");
    });
    if (_pref.getBool("skip") != null) {
      setState(() {
        skip = _pref.getBool("skip");
      });
    }
  }

  _siginOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };

    final url = Uri.parse("${MyApp.url}/user/logout");
    final user_device_id = sharedPreferences.getInt('fcmTokenId');
    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        <String, dynamic>{
          "user_device_id": user_device_id,
        },
      ),
    );
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse["successful"] && jsonResponse["type"] == "ok") {
        sharedPreferences.remove("token");
        sharedPreferences.remove("firstSecond");
        sharedPreferences.remove("userAvatar");
        sharedPreferences.remove("registrationDate");
        sharedPreferences.remove("fcmTokenId");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Logn(),
            ),
            (route) => false);
      } else {
        scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
            duration: Duration(seconds: 5),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  jsonResponse["message"],
                  style: TextStyle(
                      //  color: Colors.white,
                      fontFamily: "RubikL",
                      fontSize: 17),
                ),
                Icon(
                  Icons.error,
                  //  color: Colors.green,
                ),
              ],
            )));
      }
    } else {
      scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Error in server contact support team",
                style: TextStyle(
                    //  color: Colors.white,
                    fontFamily: "RubikL",
                    fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
              Icon(
                Icons.error,
                //  color: Colors.green,
              ),
            ],
          )));
    }

    // sharedPreferences.clear();
    // ignore: deprecated_member_use
    // sharedPreferences.commit();
  }

  _newBottomSheetChangeUserName(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "change UserName",
                          style: TextStyle(fontSize: 24),
                        )
                      ]),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      //  color: Color.fromRGBO(243, 246, 255, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: textEditingControllerFName,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'search box is Empty';
                      }
                      return null;
                    },
                    style: TextStyle(
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                        ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      icon: Icon(
                        Icons.person_rounded,
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                      ),
                    ),
                  ),
                ),
                // ignore: missing_required_param
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      //  color: Color.fromRGBO(243, 246, 255, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: textEditingControllerSName,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'search box is Empty';
                      }
                      return null;
                    },
                    style: TextStyle(
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                        ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      icon: Icon(
                        Icons.person_rounded,
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                      ),
                    ),
                  ),
                ),
                // ignore: missing_required_param
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      //  color: Color.fromRGBO(243, 246, 255, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    enabled: false,
                    controller: textEditingControllerEmail,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'search box is Empty';
                      }
                      return null;
                    },
                    style: TextStyle(
                        //  color: Colors.grey[400],
                        ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.account_circle,
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 40),
                          onPressed: () {
                            _updateName(context);
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(fontSize: 20),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        )
                      ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _changePassword(BuildContext context, String oldPassword, String newPassword,
      String confirmPassword) async {
    var w = MediaQuery.of(context).size.width;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": pref.getString("token")
    };
    var response = null, jsonResponse = null;
    var url = Uri.parse("${MyApp.url}/user/password/reset");
    if (oldPassword != null && oldPassword.isNotEmpty) {
      if (newPassword == confirmPassword) {
        response = http.post(url,
            headers: requestHeaders,
            body: jsonEncode(<String, String>{
              "oldPassword": oldPassword,
              "newPassword": newPassword,
            }));
        jsonResponse = json.decode(response.body);

        if (jsonResponse["successful"]) {
          scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
              duration: Duration(seconds: 5),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Password is updated",
                    style: TextStyle(
                        //  color: Colors.white,
                        fontFamily: "RubikL",
                        fontSize: w > 400 ? 20 : 17),
                  ),
                  Icon(
                    Icons.check,
                    //  color: Colors.green,
                  ),
                ],
              )));
        }
        if (!jsonResponse["successful"]) {
          scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
              duration: Duration(seconds: 5),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    jsonResponse["message"],
                    style: TextStyle(
                        //  color: Colors.white,
                        fontFamily: "RubikL",
                        fontSize: w > 400 ? 20 : 17),
                  ),
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.yellow,
                  ),
                ],
              )));
        }
      } else {
        scaffoldMessengerKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Input password Error",
                  style: TextStyle(
                      //  color: Colors.white,
                      fontFamily: "RubikL",
                      fontSize: w > 400 ? 20 : 17),
                ),
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.yellow,
                ),
              ],
            ),
          ),
        );
      }
    } else {
      scaffoldMessengerKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Old password is plank",
                style: TextStyle(
                    //  color: Colors.white,
                    fontFamily: "RubikL",
                    fontSize: w > 400 ? 20 : 17),
              ),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.yellow,
              ),
            ],
          ),
        ),
      );
    }
  }

  _updateName(BuildContext context) async {
    var response = null;
    var jsonResponse = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };

    if (textEditingControllerFName.text.isNotEmpty &&
        textEditingControllerSName.text.isNotEmpty) {
      var url = Uri.parse("${MyApp.url}/profile/edit");
      response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          <String, String>{
            "firstName": textEditingControllerFName.text,
            "secondName": textEditingControllerSName.text,
          },
        ),
      );
      jsonResponse = await json.decode(response.body);
      if (jsonResponse["successful"] == true) {
        setState(() {
          sharedPreferences.setStringList('firstSecond', [
            jsonResponse['data']['firstName'],
            jsonResponse['data']['secondName'],
          ]);
        });

        scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              "your name is Changed successfully",
              style: TextStyle(
                  //  color: Colors.white,
                  fontFamily: "CCL",
                  fontSize: MediaQuery.of(context).size.width > 400 ? 16 : 13),
            ),
            trailing: Icon(
              Icons.check,
              //  color: Colors.green,
            ),
          ),
        ));
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavBar(fName, 2)),
            (route) => false);
      } else {
        scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              jsonResponse["message"],
              style: TextStyle(
                  //  color: Colors.white,
                  fontFamily: "CCB",
                  fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 17),
            ),
            trailing: Icon(
              Icons.error_outline_rounded,
              //  color: Colors.yellow,
            ),
          ),
        ));
      }
    }
  }

  name() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<dynamic> list = sharedPreferences.getStringList("firstSecond");
    email = sharedPreferences.getString("email");
    setState(() {
      textEditingControllerFName.text = list[0];
      textEditingControllerSName.text = list[1];
      textEditingControllerEmail.text = email;
      fName = list[0];
      sName = list[1];
    });
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };

    try {
      var url = Uri.parse("${MyApp.url}/");
      final response = await http.get(
        url,
        headers: requestHeaders,
      );
      final jsonResponse = await json.decode(response.body);
      setState(() {
        workspaces = jsonResponse["assignedWorkspaces"].toString();
        tasks = jsonResponse["assignedTasks"].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  _newBottomSheetChangePassword(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "change Password",
                          style: TextStyle(fontSize: 24),
                        )
                      ]),
                ),

                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      //  color: Color.fromRGBO(243, 246, 255, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: textEditingControllerOldPassword,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'search box is Empty';
                      }
                      return null;
                    },
                    style: TextStyle(
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                        ),
                    decoration: InputDecoration(
                      hintText: "Enter Old Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      icon: Icon(
                        Icons.vpn_key_outlined,
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                      ),
                    ),
                  ),
                ),
                // ignore: missing_required_param
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      //  color: Color.fromRGBO(243, 246, 255, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: textEditingControllerNewPassword,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'search box is Empty';
                      }
                      return null;
                    },
                    style: TextStyle(
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                        ),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter New Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      icon: Icon(
                        Icons.vpn_key,
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                      ),
                    ),
                  ),
                ),
                // ignore: missing_required_param
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      //  color: Color.fromRGBO(243, 246, 255, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: textEditingControllerConformNewPassword,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'search box is Empty';
                      }
                      return null;
                    },
                    style: TextStyle(
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                        ),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm New Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      icon: Icon(
                        Icons.vpn_key,
                        //  color: Color.fromRGBO(0, 82, 205, 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 40),
                          onPressed: () {
                            _changePassword(
                                context,
                                textEditingControllerOldPassword.text,
                                textEditingControllerNewPassword.text,
                                textEditingControllerConformNewPassword.text);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(fontSize: 20),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        )
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _setSkip(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("skip", value);
  }
}

class Field extends StatelessWidget {
  const Field({this.colur, this.icon, this.txt, this.endd, this.onclick});

  final Color colur;
  final Icon icon;
  final String txt;
  final Widget endd;
  final Function onclick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: GestureDetector(
        onTap: onclick,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colur,
                ),
                child: icon,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.04,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      txt,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
              ),
              endd
            ],
          ),
        ),
      ),
    );
  }
}
