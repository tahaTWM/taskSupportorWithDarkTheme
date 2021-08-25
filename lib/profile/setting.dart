import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isSwitched = false;
  bool notificatoins = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Settings",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          wordSpacing: 3,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(55)),
                          color: Colors.red,
                        ),
                        //       image: DecorationImage(
                        //           image: NetworkImage(
                        //               "https://static01.nyt.com/newsgraphics/2020/11/12/fake-people/4b806cf591a8a76adfc88d19e90c8c634345bf3d/fallbacks/mobile-01.jpg"),
                        //           fit: BoxFit.cover)),
                        // )
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.deepOrangeAccent,
                          child: ClipOval(
                            child: Image.network(
                              "https://static01.nyt.com/newsgraphics/2020/11/12/fake-people/4b806cf591a8a76adfc88d19e90c8c634345bf3d/fallbacks/mobile-01.jpg",
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
                              "maia",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Edit personal details",
                              style: TextStyle(
                                  fontSize: 22, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.19,
                      ),
                      InkWell(
                        onTap: () {
                          print("Edit personal details");
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 32,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Field(
                    onclick: () {},
                    colur: Colors.brown[900],
                    icon: Icon(
                      Icons.wb_sunny,
                      color: Colors.white,
                    ),
                    txt: "Dark Mode       ",
                    endd: Switch(
                      value: isSwitched,
                      inactiveTrackColor: Colors.black12,
                      activeTrackColor: Colors.greenAccent,
                      activeColor: Colors.greenAccent,
                      inactiveThumbColor: Colors.greenAccent,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
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
                            color: Colors.black54),
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
                      txt: "Edit Profile             ",
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
                            color: Colors.black54),
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
                    txt: "Notificatoins   ",
                    endd: Switch(
                      value: notificatoins,
                      inactiveTrackColor: Colors.black12,
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
                ],
              ),
            ),
          )),
    );
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
                width: MediaQuery.of(context).size.width * 0.09,
                height: MediaQuery.of(context).size.height * 0.055,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: colur,
                ),
                child: icon,
              ),
              Text(
                txt,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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

  void setState(Null Function() param0) {}
}
