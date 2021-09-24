import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'package:app2/navBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List listOfNotifactions = [];
  bool notFoundNotification = false;
  bool value = false;
  bool thememode;

  @override
  void initState() {
    super.initState();
    _getNotifiaction();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey.withOpacity(0.1),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
                onPressed: () => _getNotifiaction(),
                icon: Icon(
                  Icons.refresh,
                  size: 25,
                )),
          )
        ],
        title: Text(
          "Notifications",
          style: TextStyle(
              //  color: Colors.black,
              ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          // color: Colors.blue,
          size: 28,
        ),
        leading: Container(),
      ),
      body: !notFoundNotification
          ? Center(child: CircularProgressIndicator())
          : listOfNotifactions.isEmpty
              ? Center(
                  child: Text(
                    "No Notification found!!",
                    style: TextStyle(
                        fontFamily: "RubikL", fontSize: width < 400 ? 23 : 28),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _getNotifiaction,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: listOfNotifactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      // ignore: non_constant_identifier_names
                      var triggered_data = json
                          .decode(listOfNotifactions[index]["triggered_data"]);
                      // ignore: non_constant_identifier_names
                      var notification_payload = json.decode(
                          listOfNotifactions[index]["notification_payload"]);

                      // print(triggered_data);
                      // print(notification_payload);
                      return listOfNotifactions[index]["notification_type"] !=
                              "TASK"
                          ? ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 17),
                              leading: triggered_data["triggere_avatar"] ==
                                          null ||
                                      triggered_data["triggere_avatar"]
                                          .toString()
                                          .contains("null")
                                  ? Container(
                                      width: 55,
                                      height: 55,
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          triggered_data[
                                                  "triggered_by_firstName"][0]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: "RubikB",
                                              fontSize: 20),
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        "${MyApp.url}${triggered_data["triggere_avatar"]}",
                                        height: 53,
                                        width: 53,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        Text(
                                          triggered_data[
                                                  "triggered_by_firstName"] +
                                              " " +
                                              triggered_data[
                                                  "triggered_by_secondName"],
                                          style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          " " +
                                              notification_payload[
                                                  "notify_title"],
                                        ),
                                        Text(
                                            " " +
                                                notification_payload[
                                                    "workspaceName"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    timeago.format(
                                        DateTime.parse(listOfNotifactions[index]
                                            ["creation_date"]),
                                        locale: 'en_short'),
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  400
                                              ? 20
                                              : 14,
                                      fontFamily: "Rubik",
                                      // color:Color.fromRGBO(158, 158, 158, 1),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10),
                                          ),
                                          onPressed: () => _acceptInvition(
                                              notification_payload[
                                                  "workspaceId"],
                                              listOfNotifactions[index]["id"],
                                              true),
                                          child: Text(
                                            'Accept',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                    SizedBox(width: 10),
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                        color: Color.fromRGBO(58, 66, 79, 1),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10),
                                        ),
                                        onPressed: ()
                                            // {
                                            //   print(notification_payload[
                                            //       "workspaceId"]);
                                            //   print(
                                            //       listOfNotifactions[index]
                                            //           ["id"]);
                                            // },
                                            =>
                                            _acceptInvition(
                                                notification_payload[
                                                    "workspaceId"],
                                                listOfNotifactions[index]["id"],
                                                false),
                                        child: Text(
                                          'Ignore',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ],
                                ),
                              ),
                            )
                          : ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 17),
                              leading: triggered_data["triggere_avatar"] ==
                                          null ||
                                      triggered_data["triggere_avatar"]
                                          .toString()
                                          .contains("null")
                                  ? Container(
                                      width: 55,
                                      height: 55,
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          triggered_data[
                                                  "triggered_by_firstName"][0]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: "RubikB",
                                              fontSize: 20),
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        "${MyApp.url}${triggered_data["triggere_avatar"]}",
                                        height: 53,
                                        width: 53,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                          triggered_data[
                                                  "triggered_by_firstName"] +
                                              " " +
                                              triggered_data[
                                                  "triggered_by_secondName"],
                                          style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(" " +
                                            notification_payload[
                                                "notify_title"] +
                                            " "),
                                        Text(
                                          notification_payload["taskTitle"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    timeago.format(
                                        DateTime.parse(listOfNotifactions[index]
                                            ["creation_date"]),
                                        locale: 'en_short'),
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  400
                                              ? 22
                                              : 18,
                                      fontFamily: "Rubik",
                                      // color:Color.fromRGBO(158, 158, 158, 1),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
    );
  }

  // ignore: unused_element
  Future<void> _getNotifiaction() async {
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
    final jsonResponse = await json.decode(response.body);
    if (jsonResponse["successful"] == true) {
      if (mounted) {
        setState(() {
          thememode = sharedPreferences.getBool("mode") ?? false;

          notFoundNotification = true;
        });
        if (jsonResponse["data"] != null)
          setState(() {
            listOfNotifactions = jsonResponse["data"];
          });
      }
    } else {
      setState(() {
        listOfNotifactions = [];
      });
    }
  }

  _acceptInvition(int workspaceId, int notificationId, bool acc) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": _pref.getString("token")
    };
    var url = Uri.parse("${MyApp.url}/workspace/accept");
    final response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        <String, dynamic>{
          "workspaceId": workspaceId,
          "isAccepted": acc,
          "notifyId": notificationId,
        },
      ),
    );
    final jsonResponse = json.decode(response.body);

    if (jsonResponse["type"] == "accepted") {
      setState(() {
        _getNotifiaction();
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavBar(0)));
    }
    if (jsonResponse["type"] == "ignore") {
      setState(() {
        _getNotifiaction();
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavBar(0)));
    }
  }
}
