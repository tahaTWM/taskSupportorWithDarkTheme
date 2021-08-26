import 'package:app2/login/logn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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
  @override
  void initState() {
    _getthemeBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Settings",
            textAlign: TextAlign.start,
            style: TextStyle(
              wordSpacing: 3,
              // fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 5),
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  print("test");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(55)),
                            // color: Colors.red,
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.deepOrangeAccent,
                            child: userAvatar == null || userAvatar == "null"
                                ? Text(
                                    widget.title.toString()[0].toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: "RubikB"),
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      "${MyApp.url}$userAvatar",
                                      height: 55,
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Personal details",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 32,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Porfile',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Field(
                  onclick: () {
                    print("Edit Profile");
                  },
                  colur: Colors.orangeAccent,
                  icon: Icon(
                    Icons.emoji_people,
                    color: Colors.white,
                    size: 26,
                  ),
                  txt: "Edit Profile",
                  endd: Icon(
                    Icons.keyboard_arrow_right,
                    size: 32,
                  )),
              Field(
                  onclick: () {
                    print("Change Password");
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
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Notificatoins',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Field(
                onclick: () {},
                colur: Colors.green,
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 28,
                ),
                txt: "  Notificatoins",
                endd: Switch(
                  value: notificatoins,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: Colors.greenAccent,
                  activeColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.greenAccent,
                  onChanged: (value) {
                    setState(() {
                      notificatoins = value;
                      print(notificatoins);
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Regional',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Field(
                onclick: () {
                  print("Language");
                },
                colur: Colors.purple,
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                  size: 26,
                ),
                txt: "Language",
                endd: Icon(
                  Icons.keyboard_arrow_right,
                  size: 32,
                ),
              ),
              Field(
                onclick: () async {
                  SharedPreferences _pref =
                      await SharedPreferences.getInstance();
                  print(_pref.getKeys());
                  _siginOut();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Logn()));
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
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    "App var 0.0.1",
                    style: TextStyle(),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _changeTheme(bool mode) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setBool("mode", mode);
  }

  _getthemeBool() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = _pref.getBool("mode");
      userAvatar = _pref.getString("userAvatar");
    });
  }

  _siginOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
    sharedPreferences.remove("firstSecond");
    sharedPreferences.remove("userAvatar");
    sharedPreferences.remove("token");
    // sharedPreferences.clear();
    // ignore: deprecated_member_use
    // sharedPreferences.commit();
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
