import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TaskActions extends StatefulWidget {
  String title;
  String prority;
  int taskID;

  TaskActions({@required this.title, @required this.prority, this.taskID});

  @override
  _TaskActionsState createState() => _TaskActionsState();
}

class _TaskActionsState extends State<TaskActions>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  TabController _tabController;

  var _history = [];
  var _timeSort = [];

  bool historyFound = false;
  bool thememode;
  @override
  void initState() {
    getHistory();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var padding = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => getHistory(), icon: Icon(Icons.refresh))
        ],
        elevation: 0.0,
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: 22,
              //  color:Colors.black,
              fontFamily: "RubikL",
              fontWeight: FontWeight.w800),
        ),
      ),

      // radius: Radius.circular(5),
      //           isAlwaysShown: true,
      //           controller: scrollController,
      body: historyFound == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _history.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: getHistory,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: _history.length,
                    itemBuilder: (BuildContext context, int index) {
                      var url = "${MyApp.url}${_history[index]["user_avatar"]}";
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            leading: url.contains('null') ||
                                    _history[index]["user_avatar"] == null ||
                                    _history[index]["user_avatar"] == "null"
                                ? Container(
                                    margin: EdgeInsets.only(left: 8),
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: widget.prority == "URGENT"
                                            ? Color.fromRGBO(248, 135, 135, 1)
                                            : Color.fromRGBO(46, 204, 113, 1),
                                      ),
                                      color: Colors.grey.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(_history[index]["firstName"]
                                        .toString()[0]
                                        .toUpperCase()),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(left: 8),
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
                                          _history[index]["old_task_status"] +
                                          " To " +
                                          _history[index]["new_task_status"]
                                      : "Added Attachment to The task",
                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 3,
                            ),
                            trailing:
                                //  Container(
                                //   width: w * 0.3,
                                //   child: DefaultTextStyle(
                                //     maxLines: 2,
                                //     overflow: TextOverflow.ellipsis,
                                //     style: TextStyle(
                                //       fontSize: w > 400 ? 22 : 18,
                                //       fontWeight: FontWeight.bold,
                                //       color: thememode == false
                                //           ? Colors.black
                                //           : Colors.white,
                                //       // color: Colors.primaries[Random()
                                //       //     .nextInt(Colors.primaries.length)],
                                //     ),
                                //     child: AnimatedTextKit(
                                //       repeatForever: true,
                                //       animatedTexts: [
                                //         FadeAnimatedText("Task"),
                                //         FadeAnimatedText("Created At"),
                                //         FadeAnimatedText(_history[index]
                                //                 ["actionCreationDate"]
                                //             .toString()
                                //             .split(' ')[0]),
                                //         FadeAnimatedText(_history[index]
                                //                 ["actionCreationDate"]
                                //             .toString()
                                //             .split(' ')[1]
                                //             .split('.')[0]),
                                //         // FadeAnimatedText(
                                //         //     'do it RIGHT NOW!!!'),
                                //       ],
                                //     ),
                                //   ),
                                // )
                                Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                timeago.format(
                                    DateTime.parse(
                                        _history[index]["actionCreationDate"]),
                                    locale: 'en_short'),
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 400
                                          ? 22
                                          : 18,
                                  fontFamily: "Rubik",
                                  // color:Color.fromRGBO(158, 158, 158, 1),
                                ),
                              ),
                            ),
                          ),
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

  Future<void> getHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      'token': sharedPreferences.getString("token"),
    };
    var url = Uri.parse('${MyApp.url}/workspace/task/${widget.taskID}');
    final response = await http.get(
      url,
      headers: requestHeaders,
    );

    final jsonResponse = json.decode(response.body);
    if (jsonResponse["successful"] == true && jsonResponse['type'] == "ok") {
      setState(() {
        thememode = sharedPreferences.getBool("mode") ?? false;

        historyFound = true;
      });
      if (jsonResponse["data"]["taskActions"] != null) {
        List<dynamic> notRev = jsonResponse["data"]["taskActions"];
        setState(() {
          _history = notRev.reversed.toList();
        });
      }
    }
  }
}
