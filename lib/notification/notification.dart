import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:timeago/timeago.dart' as timeago;
import '../main.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List listOfNotifactions = [];
  bool mode = false;
  bool value = false;

  @override
  void initState() {
    super.initState();
    _getNotifiaction();
    _getmdode();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.grey[350],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Notifications",
          style: TextStyle(
              //  color: Colors.black,
              ),
        ),
        centerTitle: true,
        // actions: [
        //   Container(
        //     decoration: BoxDecoration(
        //       // color: Colors.grey.withOpacity(0.1),
        //       borderRadius: BorderRadius.circular(18),
        //     ),
        //     padding: EdgeInsets.symmetric(horizontal: 1),
        //     margin: EdgeInsets.only(right: 5, top: 5, bottom: 2),
        //     child: PopupMenuButton(
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(15.0))),
        //       icon: Icon(
        //         Icons.more_vert,
        //         size: width > 400 ? 30 : 20,
        //         //  color: Colors.blue,
        //       ),
        //       itemBuilder: (context) => [
        //         PopupMenuItem(
        //             value: 1,
        //             child: Text(
        //               "Make it as read",
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontFamily: "RubicB",
        //               ),
        //             )),
        //         PopupMenuItem(
        //           value: 2,
        //           child: Text(
        //             "Clear all",
        //             style: TextStyle(
        //               fontSize: 20,
        //               fontFamily: "RubicB",
        //             ),
        //           ),
        //         ),
        //       ],
        //       onSelected: (item) {
        //         switch (item) {
        //           case 1:
        //             {
        //               for (var i = 0; i < list.length; i++) {
        //                 setState(() {
        //                   list[i].isSelected = false;
        //                 });
        //               }
        //             }
        //             break;
        //           case 2:
        //             {
        //               setState(() {
        //                 list = [];
        //               });
        //             }
        //             break;
        //         }
        //       },
        //     ),
        //   )
        // ],
        iconTheme: IconThemeData(
          // color: Colors.blue,
          size: 28,
        ),
        leading: Container(),
      ),
      body: listOfNotifactions.isEmpty
          ? Center(
              child: Text(
                "No Notification found!!",
                style: TextStyle(
                    fontFamily: "RubikL", fontSize: width < 400 ? 23 : 28),
              ),
            )
          : ListView.builder(
              itemCount: listOfNotifactions.length,
              itemBuilder: (BuildContext context, int index) {
                // ignore: non_constant_identifier_names
                var triggered_data =
                    json.decode(listOfNotifactions[index]["triggered_data"]);
                // ignore: non_constant_identifier_names
                var notification_payload = json
                    .decode(listOfNotifactions[index]["notification_payload"]);
                // print(listOfNotifactions[index]);
                // print(triggered_data);
                // print(notification_payload);
                return listOfNotifactions[index]["notification_type"] != "TASK"
                    ? ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        leading: triggered_data["triggere_avatar"] == null ||
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
                                    triggered_data["triggered_by_firstName"][0]
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: "RubikB", fontSize: 20),
                                  ),
                                ),
                              )
                            : Container(
                                width: 55,
                                height: 55,
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "${MyApp.url}${triggered_data["triggere_avatar"]}"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: new TextSpan(
                                style: TextStyle(
                                    color: !mode ? Colors.black : null),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: triggered_data[
                                            "triggered_by_firstName"] +
                                        " " +
                                        triggered_data[
                                            "triggered_by_secondName"],
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " " +
                                        notification_payload["notify_title"],
                                  ),
                                  TextSpan(
                                      text: " " +
                                          notification_payload["workspaceName"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(timeago.format(DateTime.parse(
                                listOfNotifactions[index]["creation_date"]))),
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
                                        notification_payload["workspaceId"],
                                        listOfNotifactions[index]["id"],
                                        true),
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              SizedBox(width: 10),
                              // ignore: deprecated_member_use
                              RaisedButton(
                                  color: Color.fromRGBO(58, 66, 79, 1),
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10),
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
                                          notification_payload["workspaceId"],
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
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        leading: triggered_data["user_avatar"] == null ||
                                triggered_data["user_avatar"]
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
                                    triggered_data["triggered_by_firstName"][0]
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: "RubikB", fontSize: 20),
                                  ),
                                ),
                              )
                            : Container(
                                width: 55,
                                height: 55,
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "${MyApp.url}${triggered_data["user_avatar"]}"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: new TextSpan(
                                style: TextStyle(
                                    color: !mode ? Colors.black : null),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: triggered_data[
                                            "triggered_by_firstName"] +
                                        " " +
                                        triggered_data[
                                            "triggered_by_secondName"],
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                      text: " " +
                                          notification_payload["notify_title"] +
                                          " "),
                                  TextSpan(
                                    text: notification_payload["task_title"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(timeago.format(DateTime.parse(
                                listOfNotifactions[index]["creation_date"]))),
                          ],
                        ),
                      );
              },
            ),
    );
  }

  // ignore: unused_element
  _getNotifiaction() async {
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
    final jsonResponse = json.decode(response.body);
    if (jsonResponse["successful"] == true && jsonResponse["type"] == "ok") {
      setState(() {
        listOfNotifactions = jsonResponse["data"];
      });
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
    print(jsonResponse);
    if (jsonResponse["type"] == "accepted") {
      setState(() {
        _getNotifiaction();
      });
    }
    if (jsonResponse["type"] == "ignore") {
      setState(() {
        _getNotifiaction();
      });
    }
  }

  _getmdode() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      mode = _pref.getBool("mode");
    });
  }
}
