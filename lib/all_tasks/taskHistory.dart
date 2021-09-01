import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

import 'package:http/http.dart' as http;

import 'package:timeago/timeago.dart' as timeago;

class TaskHistory extends StatefulWidget {
  String title;
  String prority;
  int taskID;

  TaskHistory({@required this.title, @required this.prority, this.taskID});

  @override
  _TaskHistoryState createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  TabController _tabController;

  var _history = [];
  var _timeSort = [];

  bool historyFound = false;

  @override
  void initState() {
    _getHistory(widget.taskID);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var padding = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
    return Scaffold(
      // backgroundColor: Color.fromRGBO(243, 246, 255, 1),
      appBar: AppBar(
        // backgroundColor: widget.prority == "URGENT"
        //     ? Color.fromRGBO(248, 135, 135, 1)
        //     : Color.fromRGBO(46, 204, 113, 1),
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: 22,
              //  color:Colors.black,
              fontFamily: "RubikL",
              fontWeight: FontWeight.w800),
        ),

        elevation: 0,
      ),
      body: historyFound == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _history.isNotEmpty
              ? Scrollbar(
                  radius: Radius.circular(5),
                  isAlwaysShown: true,
                  controller: scrollController,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _history.length,
                      itemBuilder: (BuildContext context, int index) {
                        var url =
                            "${MyApp.url}${_history[index]["user_avatar"]}";
                        return Column(
                          children: [
                            ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                leading: url.contains('null') ||
                                        _history[index]["user_avatar"] ==
                                            null ||
                                        _history[index]["user_avatar"] == "null"
                                    ? Container(
                                        padding: EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: widget.prority == "URGENT"
                                                ? Color.fromRGBO(
                                                    248, 135, 135, 1)
                                                : Color.fromRGBO(
                                                    46, 204, 113, 1),
                                          ),
                                          color: Colors.grey.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(_history[index]["firstName"]
                                            .toString()[0]
                                            .toUpperCase()),
                                      )
                                    : CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Colors.deepOrangeAccent,
                                        child: ClipOval(
                                          child: Image.network(
                                            url,
                                            height: 53,
                                            width: 53,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                title: Text(
                                  _history[index]["firstName"],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                subtitle: Text(
                                  _history[index]["action_type"] == "COMMENT"
                                      ? _history[index]["comment"]
                                      : _history[index]["action_type"] == "OPEN"
                                          ? "Changed Task Status From " +
                                              _history[index]
                                                  ["old_task_status"] +
                                              " To " +
                                              _history[index]["new_task_status"]
                                          : "Added Attachment to The task",
                                  // overflow: TextOverflow.ellipsis,
                                  // maxLines: 3,
                                ),
                                trailing: Text(timeago.format(DateTime.parse(
                                    _history[index]["actionCreationDate"])))),
                            Divider(
                              //  color:Colors.black,
                              thickness: 1,
                              indent: 50,
                              endIndent: 50,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    "No Action Found\nfor this task",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26),
                  ),
                ),
    );
  }

  _getHistory(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      'token': sharedPreferences.getString("token"),
    };
    var url = Uri.parse('${MyApp.url}/workspace/task/$id');
    final response = await http.get(
      url,
      headers: requestHeaders,
    );

    final jsonResponse = json.decode(response.body);
    print(jsonResponse);
    if (jsonResponse["successful"] == true && jsonResponse['type'] == "ok") {
      setState(() {
        historyFound = true;
      });
      if (jsonResponse["data"]["taskActions"] != null) {
        setState(() {
          _history = jsonResponse["data"]["taskActions"];
        });
      }
    }
  }
}
