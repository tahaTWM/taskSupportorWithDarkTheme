import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:timeago/timeago.dart' as timeago;
import '../main.dart';

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<ListItem<String>> list = [];
  List listOfNotifactions = [];

  @override
  void initState() {
    super.initState();
    _getNotifiaction();
  }

  bool value = false;

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
              itemCount: list.length,
              itemBuilder: _getListItemTile,
            ),
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    final notification_payload =
        jsonDecode(listOfNotifactions[index]["notification_payload"]);
    final triggered_data =
        jsonDecode(listOfNotifactions[index]["triggered_data"]);
    // print("notification_payload  " + notification_payload.toString());
    // print("triggered_data  " + triggered_data.toString());
    return listOfNotifactions[index]["notification_type"] != "TASK"
        ? ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            leading: triggered_data["user_avatar"] == null ||
                    triggered_data["user_avatar"].toString().contains("null")
                ? Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      ),
                      color: Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      triggered_data["triggered_by_firstName"][0]
                          .toString()
                          .toUpperCase(),
                      style: TextStyle(fontFamily: "RubikB", fontSize: 20),
                    ),
                  )
                : Container(
                    width: 100,
                    height: 100,
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
                    children: <TextSpan>[
                      TextSpan(
                        text: triggered_data["triggered_by_firstName"] +
                            " " +
                            triggered_data["triggered_by_secondName"],
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " " +
                            notification_payload["notification_method"] +
                            " You to join ",
                      ),
                      TextSpan(
                          text: notification_payload["workspaceName"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
                    child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10),
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
                          _acceptInvition(notification_payload["workspaceId"],
                              listOfNotifactions[index]["id"], false),
                      child: Text(
                        'Reject',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          )
        : ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            leading: triggered_data["user_avatar"] == null ||
                    triggered_data["user_avatar"].toString().contains("null")
                ? Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      ),
                      color: Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      triggered_data["triggered_by_firstName"][0]
                          .toString()
                          .toUpperCase(),
                      style: TextStyle(fontFamily: "RubikB", fontSize: 20),
                    ),
                  )
                : Container(
                    width: 100,
                    height: 100,
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
                    children: <TextSpan>[
                      TextSpan(
                        text: triggered_data["triggered_by_firstName"] +
                            " " +
                            triggered_data["triggered_by_secondName"],
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                          text:
                              " " + notification_payload["notify_title"] + " "),
                      TextSpan(
                          text: notification_payload["task_title"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text(timeago.format(DateTime.parse(
                    listOfNotifactions[index]["creation_date"]))),
              ],
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
    // print(listOfNotifactions);

    for (int i = 0; i < listOfNotifactions.length; i++)
      list.add(ListItem<String>("item $i"));
    // for (int i = 0; i < listOfNotifactions.length; i++) {
    //   print(list[i].data);
    //   print(list[i].isSelected);
    // }
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
    }
    if (jsonResponse["type"] == "ignor") {
      setState(() {
        _getNotifiaction();
      });
    }
  }
}
