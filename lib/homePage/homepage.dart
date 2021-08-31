import 'dart:convert';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../homePage/workSpaceMembers.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import '../all_tasks/showAllTasks.dart';
import '../creation/createNewWorkSpace.dart';
import '../main.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String firstName;

  HomePage(this.firstName);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listOfWorkspace = [];
  var notWorkspacefound = false;
  var role = [];
  var i = 0;
  TextEditingController _search = TextEditingController();
  TextEditingController _searchForMember = TextEditingController();
  bool keyboard = false;
  FocusNode inputNode = FocusNode();
  final _formkey = GlobalKey<FormState>();
  int usersInworkspace;
  int workspaceIndex = 0;

  int isJoined;

  var userAvatar = null;

  File image;
  String imageEvictUrl = "";

  bool theme = false;

  bool imageFound = false;

  bool likeIt = false;

  var msg = "No Workspace Add yet!!";

  TextEditingController _fName = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _searchForMember.clear();
    checkWorkSpaces();
    // Logn.getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(Duration(seconds: 3), (timer) {
    //   print(++i);
    //   // setState(() {
    //   //   checkWorkSpaces();
    //   // });
    // });
    var now = DateTime.now();
    DateTime formattedDate = now;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Form(
        key: _formkey,
        child: Scaffold(
          // backgroundColor: Color.fromRGBO(243, 246, 255, 1),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 0, right: 25, bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 5),
                          //logo and search icon
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              imageFound == false ||
                                      userAvatar == null ||
                                      userAvatar == "null"
                                  ? Container(
                                      width: width > 400 ? 60 : 40,
                                      height: width > 400 ? 60 : 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all()),
                                      child: Center(
                                        child: Text(
                                          widget.firstName
                                              .toString()
                                              .split('')[0]
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 26,
                                            // color: Colors.red,
                                            fontFamily: "CCB",
                                          ),
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        "${MyApp.url}$userAvatar",
                                        fit: BoxFit.cover,
                                        width: width > 400 ? 60 : 50,
                                        height: width > 400 ? 60 : 50,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: Container(
                                              width: width > 400 ? 60 : 40,
                                              height: width > 400 ? 60 : 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  widget.firstName
                                                      .toString()
                                                      .split('')[0]
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 26,
                                                    // color: Colors.red,
                                                    fontFamily: "CCB",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              InkWell(
                                // onTap: () {
                                //   setState(() {
                                //     theme = !theme;
                                //     _changeTheme(theme, context);
                                //   });
                                //   theme
                                //       ? Get.changeThemeMode(ThemeMode.dark)
                                //       : Get.changeThemeMode(ThemeMode.light);
                                // },
                                child: Image(
                                    image: AssetImage("asset/newLogo3.png"),
                                    width: width > 350 ? 60 : 50,
                                    height: width > 350 ? 60 : 50),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          //account text
                          child: Text(
                            "Hello, ${widget.firstName}!",
                            style: TextStyle(
                              fontSize: width > 400 ? 30 : 25,
                              fontFamily: "Rubik",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                          //wellcomeing message
                          child: Text(
                            "Are you ready to do\nsomething amazing?",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Rubik",
                              // color:  Color.fromRGBO(158, 158, 158, 1),
                            ),
                          ),
                        ),
                        //search
                        // Container(
                        //   height: 75,
                        //   margin: EdgeInsets.symmetric(vertical: 10),
                        //   padding: EdgeInsets.symmetric(horizontal: 10),
                        //   decoration: BoxDecoration(
                        //      // color:  Color.fromRGBO(243, 246, 255, 1),
                        //       borderRadius: BorderRadius.circular(10)),
                        //   child: Center(
                        //     child: TextFormField(
                        //       autofocus: keyboard,
                        //       controller: _search,
                        //       focusNode: inputNode,
                        //       onFieldSubmitted: (_) {
                        //         if (_formkey.currentState.validate())
                        //           return ScaffoldMessenger.of(context)
                        //               .showSnackBar(SnackBar(
                        //                   duration: Duration(seconds: 2),
                        //                   content: Text('search seccessful')));
                        //         else
                        //           return ScaffoldMessenger.of(context)
                        //               .showSnackBar(SnackBar(
                        //                   duration: Duration(seconds: 2),
                        //                   content: Text('search fail')));
                        //       },
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return 'search box is Empty';
                        //         }
                        //         return null;
                        //       },
                        //       style: TextStyle(
                        //         fontSize: 25,
                        //        // color:  Color.fromRGBO(0, 82, 205, 1),
                        //       ),
                        //       decoration: InputDecoration(
                        //         border: InputBorder.none,
                        //         hintText: "Search workspaces...",
                        //         // hintStyle: TextStyle(
                        //         //   fontSize: 25,
                        //         // ),
                        //         icon: Icon(Icons.search, size: 30),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 100,
                        //   height: 100,
                        //   child: image(),
                        // ),
                      ])),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        //workspace and new worksapace
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Workspace",
                                  style: TextStyle(
                                    fontSize: width < 400 ? 20 : 25,
                                    fontFamily: "Rubik",
                                    // color:  Colors.black,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: width < 400 ? 33 : 40,
                                  height: width < 400 ? 33 : 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.blue.withOpacity(0.8),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    listOfWorkspace.length != null
                                        ? listOfWorkspace.length.toString()
                                        : '0',
                                    style: TextStyle(
                                      fontSize: width < 400 ? 18 : 22,
                                      fontFamily: "Rubik",
                                      fontWeight: FontWeight.w600,
                                      // color:  Color.fromRGBO(0, 82, 205, 1),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                            RaisedButton.icon(
                              elevation: 6,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateNewWorkSpace(
                                                "Create New WorkSpace",
                                                null,
                                                null,
                                                null,
                                                userAvatar)));
                              },
                              icon: Icon(
                                Icons.add,
                                size: 30,
                                // color:  Colors.white,
                              ),
                              label: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Text(
                                  "New",
                                  style: TextStyle(
                                    fontSize: width < 400 ? 20 : 25,
                                    // color:  Colors.white,
                                  ),
                                ),
                              ),
                              // color:  Color.fromRGBO(0, 82, 205, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ],
                        ),
                      ),
                      //list view of all workspaces

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: notWorkspacefound == false
                              ? Center(child: CircularProgressIndicator())
                              : listOfWorkspace.isEmpty
                                  ? Center(
                                      child: Text(
                                        msg,
                                        style: TextStyle(
                                            fontFamily: "RubikL",
                                            fontSize: width < 400 ? 23 : 28),
                                      ),
                                    )
                                  : foundworkspace(
                                      formattedDate.toString(), context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changeTheme(bool mode, BuildContext context) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setBool("mode", mode);
    Toast.show(
      "Theme Switched",
      context,
      duration: Toast.LENGTH_SHORT,
      gravity: Toast.BOTTOM,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
    );
  }

  void evictImage(String url) {
    if (!url.contains("null")) {
      final NetworkImage provider = NetworkImage(url);
      provider.evict().then<void>((bool success) {
        if (success) debugPrint('removed image!');
      });
    }
  }

  //list view of all workspaces
  ListView foundworkspace(String formattedDate, BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        workspaceIndex = index;
        return Container(
          margin: EdgeInsets.only(top: 10, bottom: 20),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => listOfWorkspace[index]["role"] == "employer"
                        ? _showPicker(
                            context, listOfWorkspace[index]["workspaceId"])
                        : null,
                    child: !listOfWorkspace[index]["workspaceAvatar"]
                            .toString()
                            .contains("null")
                        ?
                        // Container()
                        Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2, color: Colors.white),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: image == null
                                  ? Image.network(
                                      "${MyApp.url}${listOfWorkspace[index]['workspaceAvatar']}",
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                width: 2.3,
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              listOfWorkspace[index]
                                                      ["workspaceName"]
                                                  .toString()
                                                  .split('')[0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w600),
                                            )),
                                          ),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    )
                                  : Image.file(
                                      image,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    ),
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
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
                              listOfWorkspace[index]["workspaceName"]
                                  .toString()
                                  .split('')[0]
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600),
                            )),
                          ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              listOfWorkspace[index]["isFavorite"] == 0
                                  ? _setFavorite(
                                      listOfWorkspace[index]["workspaceId"],
                                      context)
                                  : _deleteFavorite(
                                      listOfWorkspace[index]["workspaceId"],
                                      context);
                            },
                            icon: listOfWorkspace[index]["isFavorite"] == 0
                                ? Icon(
                                    Icons.star_border_rounded,
                                    size: 30,
                                    // color: Color.fromRGBO(255, 215, 0, 1),
                                  )
                                : Icon(
                                    Icons.star_rounded,
                                    size: 30,
                                    color: Color.fromRGBO(255, 195, 17, 1),
                                  )),
                        SizedBox(width: 10),
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          icon: Icon(
                            Icons.more_horiz,
                            size: 35,
                            // color:  Color.fromRGBO(132, 132, 132, 1),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    listOfWorkspace[index]["role"] == "employer"
                                        ? Icons.delete
                                        : Icons.logout,
                                    size: 25,
                                    // color:  Color.fromRGBO(158, 158, 158, 1),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    listOfWorkspace[index]["role"] == "employer"
                                        ? "Delete"
                                        : "Leave",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "RubicB",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            listOfWorkspace[index]["role"] == "employer"
                                ? PopupMenuItem(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 25,
                                          // color:
                                          // Color.fromRGBO(158, 158, 158, 1),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          "Edit",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "RubicB",
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : null,
                            PopupMenuItem(
                              value: 3,
                              child: Row(children: [
                                Icon(
                                  Icons.add_circle_rounded,
                                  size: 25,
                                  // color:  Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Add Memeber",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "RubicB",
                                  ),
                                ),
                              ]),
                            ),
                            listOfWorkspace[index]["role"] == "employer"
                                ? PopupMenuItem(
                                    value: 4,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.remove,
                                          size: 25,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          "Remove Image",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "RubicB",
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : null,
                          ],
                          onSelected: (item) {
                            switch (item) {
                              case 1:
                                {
                                  listOfWorkspace[index]["role"] == "employer"
                                      ? _confirmDeleteOrleaveWorkspace(
                                          context,
                                          "delete",
                                          listOfWorkspace[index]
                                              ["workspaceName"],
                                          listOfWorkspace[index]["workspaceId"])
                                      : _confirmDeleteOrleaveWorkspace(
                                          context,
                                          "leave",
                                          listOfWorkspace[index]
                                              ["workspaceName"],
                                          listOfWorkspace[index]
                                              ["workspaceId"]);
                                }
                                break;
                              case 2:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateNewWorkSpace(
                                                "Edit WorkSpace",
                                                listOfWorkspace[index]
                                                    ["workspaceId"],
                                                listOfWorkspace[index]
                                                    ["workspaceName"],
                                                listOfWorkspace[index]
                                                    ["workspaceDescription"],
                                                userAvatar)));
                                break;
                              case 3:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WorkSpaceMember(
                                              listOfWorkspace[index]
                                                  ["workspaceId"],
                                              userAvatar,
                                              checkWorkSpaces,
                                              "Add Member to Workspace",
                                              null,
                                            )));
                                break;
                              case 4:
                                _removeWorkspaceImage(
                                    listOfWorkspace[index]["workspaceId"],
                                    context);
                                break;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //for the task to gose to the list for all tasks
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowAllTasks(
                              listOfWorkspace[index]["workspaceName"],
                              listOfWorkspace[index]["workspaceId"],
                              listOfWorkspace[index]["role"],
                              userAvatar)));
                },
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //workspace title
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "${listOfWorkspace[index]["workspaceName"]}",
                              style: TextStyle(
                                fontSize: width > 400 ? 30 : 22,
                                fontFamily: "RubikB",
                              ),
                            ),
                          ),
                          //workspace descripition
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 30),
                            child: Text(
                              "${listOfWorkspace[index]["workspaceDescription"]}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: width > 400 ? 24 : 22,
                                fontFamily: "Rubik",
                                // color:  Color.fromRGBO(112, 112, 112, 1),
                              ),
                            ),
                          ),
                          //done task row
                          Row(children: [
                            Icon(
                              Typicons.input_checked,
                              size: 25,
                              // color:  Color.fromRGBO(112, 112, 112, 1),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Tasks",
                              style: TextStyle(
                                  // color:  Color.fromRGBO(112, 112, 112, 1),
                                  fontSize: 20),
                            ),
                          ]),
                          SizedBox(height: 10),
                          //building ui row
                          Row(
                            children: [
                              Icon(
                                Typicons.puzzle_outline,
                                size: 25,
                                // color:  Color.fromRGBO(112, 112, 112, 1),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Building UI",
                                style: TextStyle(
                                    // color:  Color.fromRGBO(112, 112, 112, 1),
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          //date row
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, top: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    child: Row(children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 25,
                                    // color:  Color.fromRGBO(112, 112, 112, 1),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    listOfWorkspace[index]["creation_date"]
                                        .toString()
                                        .split('T')[0],
                                    style: TextStyle(
                                      fontSize: 20,
                                      // color:  Color.fromRGBO(112, 112, 112, 1),
                                    ),
                                  )
                                ])),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkSpaceMember(
                                listOfWorkspace[index]["workspaceId"],
                                userAvatar,
                                checkWorkSpaces,
                                "Add Member to Workspace",
                                null,
                              ),
                            ),
                          ),
                          child: Container(
                            width: width > 1000 ? width * 0.15 : width * 0.3,
                            height: width > 1000 ? width * 0.05 : width * 0.16,
                            // color: Colors.red,
                            child: memberStack(
                                listOfWorkspace[index]["users"], context),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: listOfWorkspace.length ?? 1,
    );
  }

  checkWorkSpaces() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("userAvatar") != "null") {
      setState(() {
        imageFound = true;
        userAvatar = sharedPreferences.getString("userAvatar");
      });
    }
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    var jsonResponse = null;
    try {
      var url = Uri.parse("${MyApp.url}/workspaces");

      var response = await http.get(
        url,
        headers: requestHeaders,
      );
      jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        if (!jsonResponse["successful"]) {
          setState(() {
            notWorkspacefound = false;
          });
        } else {
          setState(() {
            notWorkspacefound = true;
            // ignore: unnecessary_statements
            if (jsonResponse['data'] != null) {
              if (listOfWorkspace != null) {
                if (listOfWorkspace != jsonResponse['data']) {
                  setState(() {
                    listOfWorkspace = jsonResponse['data'];
                  });
                }
              } else {
                setState(() {
                  listOfWorkspace = jsonResponse['data'];
                });
              }
            } else
              listOfWorkspace = [];
          });
        }
      } else if (response.statusCode == 400) {
        setState(() {
          msg = "client Error";
        });
      } else {
        setState(() {
          msg = "server Error";
        });
      }
    } catch (e) {
      setState(() {
        msg = "Error Cortact Suppot Team";
      });
    }
  }

  List images;

  Container container(Color color, String text) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        // color:  color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(child: Text(text)),
    );
  }

  delete(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // ignore: avoid_init_to_null
    var jsonResponse = null;
    try {
      var url = Uri.parse("${MyApp.url}/workspace/delete/$id");
      var response = await http.delete(
        url,
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "token": sharedPreferences.getString("token"),
        },
      );
      jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        print(jsonResponse["success"]);
        setState(() {
          checkWorkSpaces();
        });
      } else if (response.statusCode == 400) {
        print(jsonResponse["error"]);
      }
    } catch (e) {
      print(e);
    }
  }

  leave(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // ignore: avoid_init_to_null
    var jsonResponse = null;
    try {
      var url = Uri.parse("${MyApp.url}/workspace/leave/$id");
      var response = await http.delete(
        url,
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "token": sharedPreferences.getString("token"),
        },
      );
      jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        print(jsonResponse["success"]);
        setState(() {
          checkWorkSpaces();
        });
      } else if (response.statusCode == 400) {
        print(jsonResponse["error"]);
      }
    } catch (e) {
      print(e);
    }
  }

  //invite employee
  _inviteEmployee(int workspaceId, int employeeID, BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    try {
      var url = Uri.parse("${MyApp.url}/workspace/invite");
      await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          <String, dynamic>{
            "workspaceId": workspaceId,
            "employeeId": employeeID
          },
        ),
      );
      Navigator.pop(context);
      setState(() {
        checkWorkSpaces();
      });
    } catch (e) {
      print(e);
    }
  }

  //select betwen camera and storage
  _showPicker(context, int workspaceID) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery(context, workspaceID);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(context, workspaceID);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera(BuildContext context, int workspaceID) async {
    var image = (await ImagePicker.platform.getImage(
      source: ImageSource.camera,
    ));
    final File _image = File(image.path);
    if (_image != null) _showAlertDilog(context, _image, workspaceID);
  }

  _imgFromGallery(BuildContext context, int workspaceID) async {
    var image = (await ImagePicker.platform.getImage(
      source: ImageSource.gallery,
    ));
    final File _image = File(image.path);
    if (_image != null) _showAlertDilog(context, _image, workspaceID);
  }

  _showAlertDilog(BuildContext context, File _image, int workspaceID) {
    return showDialog(
        context: context,
        builder: (contect) {
          return AlertDialog(
            title: Text("Changing workspace Image"),
            content: Text(
              "Are Sure You want to Change workspace image?",
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  evictImage(imageEvictUrl);
                  setState(() {
                    image = _image;
                  });
                  _updateWorkspaceAvatar(workspaceID, context);
                  Navigator.pop(context);
                },
                child: Text("Yes"),
              ),
              RaisedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("No"),
              ),
            ],
          );
        });
  }

  _updateWorkspaceAvatar(int worksoaceID, BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    try {
      if (image != null) {
        var imageBytes = image.readAsBytesSync();
        var request = http.MultipartRequest(
            "POST", Uri.parse("${MyApp.url}/workspace/avatar/$worksoaceID"));
        request.files.add(
          http.MultipartFile.fromBytes(
            "workspaceAvatar",
            imageBytes,
            filename: basename(image.path),
            contentType: new MediaType('image', 'jpg'),
          ),
        );
        request.headers.addAll({"token": sharedPreferences.getString("token")});
        final response = await request.send();
        final resSTR = await response.stream.bytesToString();
        jsonResponse = json.decode(resSTR);
      }
      Future.delayed(Duration(seconds: 30), () {
        if (jsonResponse["successful"]) {
          // var list = sharedPreferences.getStringList("firstSecond");
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => NavBar(list[0])));
          print("waiting");

          checkWorkSpaces();
        }
      });

      if (!jsonResponse["successful"]) {
        print(jsonResponse["successful"]);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget memberStack(List list, BuildContext context) {
    if (list.length > 3) {
      return Stack(
        children: <Widget>[
          positioned(list: list, index: 0, left: 0, right: null),
          positioned(list: list, index: 1, left: 25, right: null),
          positioned(list: list, index: 2, left: 50, right: null),
          Positioned(
            left: 53,
            right: null,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Text(
                  "+" + (list.length - 3).toString(),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (list.length == 1) {
      return Stack(
        children: <Widget>[
          positioned(list: list, index: 0, left: 0, right: null),
        ],
      );
    }
    if (list.length == 2) {
      return Stack(
        children: [
          positioned(list: list, index: 0, left: 0, right: null),
          positioned(list: list, index: 1, left: 25, right: null),
        ],
      );
    }
    if (list.length == 3) {
      return Stack(
        children: [
          positioned(list: list, index: 0, left: 0, right: null),
          positioned(list: list, index: 1, left: 25, right: null),
          positioned(list: list, index: 2, left: 50, right: null),
        ],
      );
    }
  }

  Positioned positioned({List list, double left, double right, int index}) {
    return Positioned(
      left: left,
      right: right,
      child: Container(
        child: list[index]["user_avatar"] == null ||
                "${MyApp.url}${list[index]["user_avatar"]}".contains('null')
            ? Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                    color: Colors.grey),
                child: Center(
                    child: Text(
                  list[index]["firstName"]
                      .toString()
                      .split('')[0]
                      .toUpperCase()
                      .toUpperCase(),
                  style: TextStyle(color: Colors.white),
                )))
            : Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.white)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    "${MyApp.url}${list[index]["user_avatar"]}",
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                            ),
                            child: Center(
                                child: Text(list[index]["firstName"]
                                    .toString()
                                    .split('')[0]
                                    .toUpperCase()
                                    .toUpperCase()))),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  _confirmDeleteOrleaveWorkspace(
    BuildContext context,
    String _delete,
    String workspace,
    int id,
  ) async {
    SharedPreferences _pred = await SharedPreferences.getInstance();
    return _delete == "delete"
        ? showDialog(
            context: context,
            builder: (contect) {
              return AlertDialog(
                title: Text("Upload Attachment"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: new TextSpan(
                        style: TextStyle(
                            color: !_pred.getBool('mode')
                                ? Colors.black
                                : Colors.white),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Enter Your First Name to Delete this '),
                          TextSpan(
                            text: workspace,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: ' workspace?\n'),
                          TextSpan(text: '\nEnter your First Name: '),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      // width: MediaQuery.of(context).size.width - 20,
                      child: new TextFormField(
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "First Name",
                        ),
                        controller: _fName,
                      ),
                    )
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      var fName = _pred.getStringList("firstSecond");
                      if (_fName.text.toLowerCase() == fName[0].toLowerCase()) {
                        delete(id);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Yes"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("No"),
                  ),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (contect) {
              return AlertDialog(
                title: Text("Upload Attachment"),
                content: Text(
                  "Are Sure You want to Leave ${workspace} workspace?",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      leave(id);
                      Navigator.pop(context);
                    },
                    child: Text("Yes"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("No"),
                  ),
                ],
              );
            });
  }

  _setFavorite(int id, BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    try {
      var url = Uri.parse("${MyApp.url}/workspace/favorite");
      var response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          <String, dynamic>{
            "workspaceId": id,
          },
        ),
      );
      jsonResponse = json.decode(response.body);
      if (jsonResponse["successful"]) {
        Toast.show(
          jsonResponse["message"],
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        setState(() {
          checkWorkSpaces();
        });
        setState(() {
          checkWorkSpaces();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _deleteFavorite(int id, BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    try {
      var url = Uri.parse("${MyApp.url}/workspace/favorite/delete/$id");
      var response = await http.delete(
        url,
        headers: requestHeaders,
      );
      jsonResponse = json.decode(response.body);

      if (jsonResponse["successful"]) {
        Toast.show(
          jsonResponse["message"],
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        setState(() {
          checkWorkSpaces();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _removeWorkspaceImage(int id, BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };
    try {
      var url = Uri.parse("${MyApp.url}/workspace/avatar/$id");
      var response = await http.delete(
        url,
        headers: requestHeaders,
      );
      var jsonResponse = json.decode(response.body);

      if (jsonResponse["successful"]) {
        Toast.show(
          jsonResponse["message"],
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        setState(() {
          checkWorkSpaces();
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
