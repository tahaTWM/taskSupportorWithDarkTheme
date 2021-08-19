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
  List<ListItem<String>> list;

  @override
  void initState() {
    super.initState();
    populateData();
  }

  void populateData() {
    list = [];
    for (int i = 0; i < 8; i++) list.add(ListItem<String>("item $i"));
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
        actions: [
          Container(
            decoration: BoxDecoration(
              // color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: EdgeInsets.symmetric(horizontal: 1),
            margin: EdgeInsets.only(right: 5, top: 5, bottom: 2),
            child: PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              icon: Icon(
                Icons.more_vert,
                size: width > 400 ? 30 : 20,
                //  color: Colors.blue,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Make it as read",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "RubicB",
                      ),
                    )),
                PopupMenuItem(
                  value: 2,
                  child: Text(
                    "Clear all",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "RubicB",
                    ),
                  ),
                ),
              ],
              onSelected: (item) {
                switch (item) {
                  case 1:
                    {
                      for (var i = 0; i < list.length; i++) {
                        setState(() {
                          list[i].isSelected = false;
                        });
                      }
                    }
                    break;
                  case 2:
                    {
                      setState(() {
                        list = [];
                      });
                    }
                    break;
                }
              },
            ),
          )
        ],
        iconTheme: IconThemeData(
          // color: Colors.blue,
          size: 28,
        ),
        leading: Container(),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: _getListItemTile,
      ),
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (list.any((item) => item.isSelected)) {
              setState(() {
                list[index].isSelected = !list[index].isSelected;
              });
            }
          },
          onLongPress: () {
            setState(() {
              list[index].isSelected = true;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 8),
            color: list[index].isSelected
                ? Colors.grey[100].withOpacity(0.1)
                : Colors.transparent,
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
                  child: Center(
                      child: Text(
                    "T",
                    style: TextStyle(fontFamily: "RubikB", fontSize: 20),
                  )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            index % 2 == 0
                                ? Expanded(
                                    child: Text(
                                      "Unknow Sent you invite to workSpace MSMAR",
                                      maxLines: 5,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Text(
                                      "Taha",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                            PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              icon: Icon(
                                Icons.more_horiz,
                                size: 20,
                                color: Colors.white,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      "Make it as read",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "RubicB",
                                      ),
                                    )),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text(
                                    "Clear all",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "RubicB",
                                    ),
                                  ),
                                ),
                              ],
                              onSelected: (item) {
                                switch (item) {
                                  case 1:
                                    {
                                      for (var i = 0; i < list.length; i++) {
                                        setState(() {
                                          list[i].isSelected = false;
                                        });
                                      }
                                    }
                                    break;
                                  case 2:
                                    {
                                      setState(() {
                                        list = [];
                                      });
                                    }
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                        index % 2 == 0
                            ? Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(DateTime.now()
                                        .toString()
                                        .split(' ')[0]),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: ButtonTheme(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            child: RaisedButton(
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                ),
                                                onPressed: () {},
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
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            //limits the touch area to the button area
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            //wraps child's width
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            //wraps child's height
                                            child: RaisedButton(
                                                color: Color.fromRGBO(
                                                    58, 66, 79, 1),
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  'Deny',
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
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1.2,
          indent: 70,
          endIndent: 70,
        ),
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
    var jsonResponse = null;
    var url = Uri.parse("${MyApp.url}/workspaces");
    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    jsonResponse = json.decode(response.body);
    print(jsonResponse);
  }
}
