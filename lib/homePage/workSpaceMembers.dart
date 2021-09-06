import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../main.dart';

// ignore: must_be_immutable
class WorkSpaceMember extends StatefulWidget {
  int workspaceID;
  var userAvatar;
  final Function checkWorkSpaces;
  String title;
  int taskId;

  WorkSpaceMember(
    this.workspaceID,
    this.userAvatar,
    this.checkWorkSpaces,
    this.title,
    this.taskId,
  );

  @override
  _WorkSpaceMemberState createState() => _WorkSpaceMemberState();
}

class _WorkSpaceMemberState extends State<WorkSpaceMember> {
  @override
  void initState() {
    _getMember();
    super.initState();
  }

  bool keyboard = false;
  FocusNode inputNode = FocusNode();
  TextEditingController _search = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            //  color:Colors.black,
            fontFamily: 'RubikL',
          ),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: IconThemeData(
            //  color:Colors.black,
            ),
      ),
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: widget.title != "Task Members"
              ? Column(
                  children: [
                    widget.title == "Add Member to Workspace"
                        ? Container(
                            height: width < 400 ? 50 : 75,
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              //  color:Color.fromRGBO(243, 246, 255, 1),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.lightBlue, width: 2),
                            ),
                            child: Center(
                              child: TextFormField(
                                autofocus: keyboard,
                                controller: _search,
                                focusNode: inputNode,
                                onFieldSubmitted: (_) {
                                  if (_formkey.currentState.validate()) {
                                    _searchForMemberInTask(
                                        widget.workspaceID, _search.text);
                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 2),
                                            content:
                                                Text('search seccessful')));
                                  } else
                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: Text('search fail')));
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'search box is Empty';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  fontSize: width < 400 ? 18 : 25,
                                  //  color:Color.fromRGBO(0, 82, 205, 1),
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search for Member",
                                  // hintStyle: TextStyle(
                                  //   fontSize: 25,
                                  // ),
                                  icon: Icon(Icons.search, size: 30),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Container(
                        width: width,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            var image =
                                listOfWorkspaceMembers[index]["user_avatar"];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: listOfWorkspaceMembers[index]
                                                        ["user_avatar"] ==
                                                    null
                                                ? Container(
                                                    width:
                                                        width < 400 ? 50 : 60,
                                                    height:
                                                        width < 400 ? 50 : 60,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                            listOfWorkspaceMembers[
                                                                        index][
                                                                    "firstName"]
                                                                .toString()
                                                                .split('')[0]
                                                                .toUpperCase())))
                                                : Image.network(
                                                    "${MyApp.url}$image",
                                                    fit: BoxFit.cover,
                                                    width:
                                                        width < 400 ? 50 : 60,
                                                    height:
                                                        width < 400 ? 50 : 60,
                                                  )),
                                        SizedBox(width: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listOfWorkspaceMembers[index]
                                                  ['firstName'],
                                              style: TextStyle(
                                                fontSize: width < 400 ? 18 : 22,
                                                //  color:Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              listOfWorkspaceMembers[index]
                                                  ['secondName'],
                                              style: TextStyle(
                                                fontSize: width < 400 ? 18 : 22,
                                                //  color:Colors.black,
                                              ),
                                            ),
                                            Text(
                                              listOfWorkspaceMembers[index]
                                                          ["isAccpeted"] ==
                                                      0
                                                  ? " (pending)"
                                                  : "",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    widget.title == "Add Member to Workspace"
                                        ? listOfWorkspaceMembers[index]["role"] ==
                                                "employer"
                                            ? Text("Owner")
                                            : listOfWorkspaceMembers[index]
                                                        ["isJoined"] ==
                                                    0
                                                ? IconButton(
                                                    onPressed: () {
                                                      _inviteEmployeeToWorkspace(
                                                          listOfWorkspaceMembers[
                                                              index]["userId"]);
                                                    },
                                                    icon: Icon(
                                                      Icons.person_add_rounded,
                                                      size:
                                                          width < 400 ? 25 : 35,
                                                      //  color:Colors.green,
                                                    ))
                                                : listOfWorkspaceMembers[index]
                                                            ["isAccepted"] ==
                                                        0
                                                    ? Text("Pendding")
                                                    : IconButton(
                                                        onPressed: () =>
                                                            _kickUserfromTaskOrWorkspace(
                                                                widget.taskId,
                                                                listOfWorkspaceMembers[index]
                                                                    ["userId"]),
                                                        icon: Icon(
                                                          Icons.remove,
                                                          size: width < 400
                                                              ? 25
                                                              : 35,
                                                          color: Colors.red,
                                                        ))
                                        : widget.title == "Add Member to Task"
                                            ? listOfWorkspaceMembers[index]
                                                        ["isWorkspaceOwner"] ==
                                                    0
                                                ? listOfWorkspaceMembers[index]
                                                            ["isInTask"] ==
                                                        1
                                                    ? IconButton(
                                                        onPressed: () =>
                                                            _kickUserfromTaskOrWorkspace(
                                                                widget.taskId,
                                                                listOfWorkspaceMembers[index]
                                                                    ["userId"]),
                                                        icon: Icon(
                                                          Icons.remove,
                                                          size: width < 400
                                                              ? 25
                                                              : 35,
                                                          color: Colors.red,
                                                        ))
                                                    : IconButton(
                                                        onPressed: () {
                                                          _inviteEmployeeToTask(
                                                              widget.taskId,
                                                              listOfWorkspaceMembers[
                                                                      index]
                                                                  ["userId"]);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .person_add_rounded,
                                                          size: width < 400
                                                              ? 25
                                                              : 35,
                                                          //  color:Colors.green,
                                                        ))
                                                : Container()
                                            : Container()
                                  ]),
                            );
                          },
                          itemCount: listOfWorkspaceMembers.length,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (BuildContext context, int index) {
                      var image = listOfWorkspaceMembers[index]["user_avatar"];
                      print(listOfWorkspaceMembers);
                      return listOfWorkspaceMembers[index]["isInTask"] == 1 ||
                              listOfWorkspaceMembers[index]
                                      ["isWorkspaceOwner"] ==
                                  1
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: listOfWorkspaceMembers[index]
                                                        ["user_avatar"] ==
                                                    null
                                                ? Container(
                                                    width:
                                                        width < 400 ? 50 : 60,
                                                    height:
                                                        width < 400 ? 50 : 60,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                            listOfWorkspaceMembers[
                                                                        index][
                                                                    "firstName"]
                                                                .toString()
                                                                .split('')[0]
                                                                .toUpperCase())))
                                                : Image.network(
                                                    "${MyApp.url}$image",
                                                    fit: BoxFit.cover,
                                                    width:
                                                        width < 400 ? 50 : 60,
                                                    height:
                                                        width < 400 ? 50 : 60,
                                                  )),
                                        SizedBox(width: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listOfWorkspaceMembers[index]
                                                  ['firstName'],
                                              style: TextStyle(
                                                fontSize: width < 400 ? 18 : 22,
                                                //  color:Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              listOfWorkspaceMembers[index]
                                                  ['secondName'],
                                              style: TextStyle(
                                                fontSize: width < 400 ? 18 : 22,
                                                //  color:Colors.black,
                                              ),
                                            ),
                                            Text(
                                              listOfWorkspaceMembers[index]
                                                          ["isAccpeted"] ==
                                                      0
                                                  ? " (pending)"
                                                  : "",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    listOfWorkspaceMembers[index]
                                                ["isWorkspaceOwner"] ==
                                            1
                                        ? Text(
                                            "Workspace\nOwner",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          )
                                        : IconButton(
                                            onPressed: () =>
                                                _kickUserfromTaskOrWorkspace(
                                                    widget.taskId,
                                                    listOfWorkspaceMembers[
                                                        index]["userId"]),
                                            icon: Icon(
                                              Icons.remove,
                                              size: width < 400 ? 25 : 35,
                                              color: Colors.red,
                                            ))
                                  ]),
                            )
                          : Container();
                    },
                    itemCount: listOfWorkspaceMembers.length,
                  ),
                ),
        ),
      ),
    );
  }

  // search for member
  _searchForMemberInTask(int workSpaceID, String searchcontent) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token"),
    };

    var jsonResponse = null;
    var url = Uri.parse(
        "${MyApp.url}/workspace/members/seek/$workSpaceID/$searchcontent");
    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    jsonResponse = json.decode(response.body);
    if (jsonResponse["data"] != null)
      setState(() {
        listOfWorkspaceMembers = jsonResponse["data"];
      });
  }

  var listOfWorkspaceMembers = [];
  _getMember() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    var jsonResponse = null;
    Uri url;
    if (widget.title == "Add Member to Task") {
      url = Uri.parse(
          "${MyApp.url}/workspace/${widget.workspaceID}/task/${widget.taskId}/members");
    } else if (widget.title == "Task Members") {
      url = Uri.parse(
          "${MyApp.url}/workspace/${widget.workspaceID}/task/${widget.taskId}/members");
    } else {
      url = Uri.parse("${MyApp.url}/workspace/${widget.workspaceID}");
    }

    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    jsonResponse = json.decode(response.body);

    setState(() {
      listOfWorkspaceMembers =
          widget.title == "Add Member to Task" || widget.title == "Task Members"
              ? jsonResponse["data"]
              : jsonResponse["data"]["users"];
    });
  }

  //invite employee
  _inviteEmployeeToWorkspace(int employeeID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    var url = Uri.parse("${MyApp.url}/workspace/invite");
    await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        <String, dynamic>{
          "workspaceId": widget.workspaceID,
          "employeeId": employeeID
        },
      ),
    );
    widget.checkWorkSpaces();
    setState(() {
      _getMember();
    });
    // Navigator.pop(context);
  }

  _inviteEmployeeToTask(int taskId, int newMemberId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    var url = Uri.parse("${MyApp.url}/workspace/task/add/member");
    await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        <String, dynamic>{"taskId": taskId, "newMemberId": newMemberId},
      ),
    );
    Toast.show(
      "User was added to successfully",
      context,
      backgroundColor: Colors.green,
      duration: Toast.LENGTH_LONG,
    );
    widget.checkWorkSpaces();
    Navigator.pop(context);
  }

  _kickUserfromTaskOrWorkspace(int taskID, int memberID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // ignore: avoid_init_to_null
    var jsonResponse = null;
    try {
      var url;
      if (widget.title == "Task Members" ||
          widget.title == "Add Member to Task") {
        Uri.parse("${MyApp.url}/workspace/task/$taskID/member/$memberID");
      }
      if (widget.title == "Add Member to Workspace") {
        Uri.parse("${MyApp.url}/workspace/kick");
      }

      var response = widget.title == "Task Members" ||
                  widget.title == "Add Member to Task"
              ? await http.delete(
                  url,
                  headers: {
                    "Content-type": "application/json; charset=UTF-8",
                    "token": sharedPreferences.getString("token"),
                  },
                )
              : await http.post(url,
                  headers: {
                    "Content-type": "application/json; charset=UTF-8",
                    "token": sharedPreferences.getString("token"),
                  },
                  body: jsonEncode(<String, dynamic>{
                    "workspaceId": widget.workspaceID,
                    "memberId": memberID
                  })),
          jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        if (jsonResponse["successful"] == true) {
          setState(() {
            _getMember();
          });
          widget.checkWorkSpaces();
          Toast.show(
            "User was Kicked successfully",
            context,
            backgroundColor: Colors.pink,
            duration: Toast.LENGTH_LONG,
          );
        }
        Toast.show(
          jsonResponse["message"],
          context,
          backgroundColor: Colors.purple,
          duration: Toast.LENGTH_LONG,
        );
      } else if (response.statusCode == 500) {
        print(jsonResponse["error"]);
      }
    } catch (e) {
      print(e);
    }
  }
}
