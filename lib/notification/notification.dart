import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
                child: triggered_data["user_avatar"] == null ||
                        triggered_data["user_avatar"]
                            .toString()
                            .contains("null")
                    ? Center(
                        child: Text(
                        triggered_data["triggered_by_firstName"][0]
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(fontFamily: "RubikB", fontSize: 20),
                      ))
                    : Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "${MyApp.url}${triggered_data["user_avatar"]}",
                                ))),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        notification_payload["notification_method"] == "INVITE"
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      triggered_data["triggered_by_firstName"] +
                                          " " +
                                          triggered_data[
                                              "triggered_by_secondName"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " " +
                                          notification_payload[
                                              "notification_method"] +
                                          " You to join ",
                                      maxLines: 5,
                                    ),
                                    Text(
                                      notification_payload["workspaceName"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                "Taha",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                      ],
                    ),
                    notification_payload["notification_method"] == "INVITE"
                        ? Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listOfNotifactions[index]["creation_date"]
                                    .toString()
                                    .split('T')[0]),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ButtonTheme(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )), //your original button
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: ButtonTheme(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        //adds padding inside the button
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        //limits the touch area to the button area
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        //wraps child's width
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        //wraps child's height
                                        child: RaisedButton(
                                            color:
                                                Color.fromRGBO(58, 66, 79, 1),
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
                                                    listOfNotifactions[index]
                                                        ["id"],
                                                    false),
                                            child: Text(
                                              'Reject',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )), //your original button
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Text(
                            "name2",
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Divider(
        //   thickness: 1.2,
        //   indent: 70,
        //   endIndent: 70,
        // ),
      ],
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
    // print(jsonResponse);

    for (int i = 0; i < listOfNotifactions.length; i++)
      list.add(ListItem<String>("item $i"));
    for (int i = 0; i < listOfNotifactions.length; i++) {
      print(list[i].data);
      print(list[i].isSelected);
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
    }
    if (jsonResponse["type"] == "ignor") {
      setState(() {
        _getNotifiaction();
      });
    }
  }
}
