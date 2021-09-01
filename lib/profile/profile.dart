import 'dart:convert';
import 'dart:io';
import 'package:app2/profile/setting.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gets.dart';
import '../main.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';

class Profile extends StatefulWidget {
  String fn;

  Profile(this.fn);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool timeZoneSwitch = false;
  bool showAllEventSwitch = false;
  bool emailNotifSwitch = false;
  var profileName = '';
  String fName = '';
  String sName = '';
  String email = '';
  String creationDate = '';
  TextEditingController textEditingControllerFName = TextEditingController();
  TextEditingController textEditingControllerSName = TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerConformNewPassword =
      TextEditingController();

  TextEditingController textEditingControllerOldPassword =
      TextEditingController();
  TextEditingController textEditingControllerNewPassword =
      TextEditingController();

  File image;

  String workspaces = "0";
  String tasks = "0";
  final ImagePicker _picker = ImagePicker();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  var imagePath = "";

  bool imageFound = false;

  String createDataDay = '';
  String createDataTime = '';

  int notifications = 0;
  @override
  void initState() {
    super.initState();
    name();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          // backgroundColor: Color.fromRGBO(250, 250, 250, 2),
          elevation: 0,
          title: Text(
            "Profile",
            style: TextStyle(
                //  color: Colors.black,
                ),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Setting(fName))),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.only(right: 5, top: 5, bottom: 2),
                child: Icon(Icons.settings),
              ),
            )
          ],
          iconTheme: IconThemeData(
            //  color: Colors.blue,
            size: 28,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(),
                ),
                child: Stack(
                  children: [
                    imageFound == false ||
                            imagePath == null ||
                            imagePath == "null"
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                            ),
                            child: Center(
                              child: Text(
                                widget.fn[0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: width > 400 ? 80 : 60,
                                    fontFamily: "CCB"),
                              ),
                            ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: image == null
                                ? Image.network(
                                    "${MyApp.url}$imagePath",
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: MediaQuery.of(context).size.width *
                                        0.45,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(),
                                          ),
                                          child: Center(
                                            child: Text(
                                              fName[0].toUpperCase(),
                                              style: TextStyle(
                                                  fontSize:
                                                      width > 400 ? 80 : 40,
                                                  fontFamily: "CCB"),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Image.file(
                                    image,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: MediaQuery.of(context).size.width *
                                        0.45,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showPicker(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.05,
                          color: Colors.grey.withOpacity(0.6),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: width > 400 ? 30 : 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: width > 400 ? 30 : 10,
              // ),
              Text(
                fName + " " + sName,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              workspaces,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width > 400 ? 22 : 18),
                            )),
                        // SizedBox(height: 5),
                        Text(
                          "Workspace",
                          style: TextStyle(
                              //  color: Colors.grey[700],
                              fontSize: width > 400 ? 22 : 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              tasks,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width > 400 ? 22 : 18),
                            )),
                        // SizedBox(height: 5),
                        Text(
                          "Tasks",
                          style: TextStyle(
                              //  color: Colors.grey[700],
                              fontSize: width > 400 ? 22 : 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              notifications.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width > 400 ? 22 : 18),
                            )),
                        // SizedBox(height: 3),
                        Text(
                          "Notifications",
                          style: TextStyle(
                              //  color: Colors.grey[700],
                              fontSize: width > 400 ? 22 : 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(127, 210, 35, 1)),
                        ),
                        SizedBox(width: 30),
                        Text(
                          "Available",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: width > 400 ? 22 : 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 35, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Icon(Icons.email_outlined),
                        SizedBox(width: 20),
                        Text(
                          textEditingControllerEmail.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: width > 400 ? 22 : 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, top: 10),
                    child: Row(
                      children: [
                        Icon(Icons.more_time_rounded),
                        SizedBox(width: 20),
                        Row(
                          children: [
                            Text(
                              createDataDay + "  at  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: width > 400 ? 22 : 18),
                            ),
                            Text(
                              createDataTime.split('.')[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: width > 400 ? 22 : 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // SizedBox(
              //   height: width > 400 ? 50 : 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _changeTheme(bool mode) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setBool("mode", mode);
  }

  _imgFromGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    var image = (await ImagePicker.platform.getImage(
      source: ImageSource.gallery,
    ));
    final File _image = File(image.path);

    if (_image != null) _showAlertDilog(context, _image as File);
  }

  _imgFromCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    var image = (await ImagePicker.platform.getImage(
      source: ImageSource.camera,
    ));

    final File _image = File(image.path);

    if (_image != null) _showAlertDilog(context, _image as File);
  }

  uploadimage(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (image != null) {
      var imageType = lookupMimeType(image.path);
      var imageBytes = image.readAsBytesSync();
      var request =
          http.MultipartRequest("POST", Uri.parse("${MyApp.url}/user/avatar"));
      request.files.add(
        http.MultipartFile.fromBytes(
          "userAvatar",
          imageBytes,
          filename: basename(image.path),
          contentType:
              MediaType(imageType.split('/')[0], imageType.split('/')[1]),
        ),
      );
      request.headers.addAll({"token": sharedPreferences.getString("token")});
      final response = await request.send();
      final resSTR = await response.stream.bytesToString();

      showsnakbar(json.decode(resSTR), context);
    }
  }

  //select betwen camera and storage
  _showPicker(context) {
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
                        _imgFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.remove, color: Colors.red),
                    title: new Text('Remove image'),
                    onTap: () {
                      _removeimage();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  bottomsheet(BuildContext context, String select) {
    if (select == "Change Password")
      return showAdaptiveActionSheet(
        context: context,

        title: const Text('Change Password'),
        // bottomSheetColor: Color.fromRGBO(226, 234, 246, 1),
        actions: <BottomSheetAction>[
          // ignore: missing_required_param
          BottomSheetAction(
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  //  color: Color.fromRGBO(243, 246, 255, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: textEditingControllerOldPassword,
                onFieldSubmitted: (_) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'search box is Empty';
                  }
                  return null;
                },
                style: TextStyle(
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                    ),
                decoration: InputDecoration(
                  hintText: "Enter Old Password",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  icon: Icon(
                    Icons.vpn_key_outlined,
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                  ),
                ),
              ),
            ),
          ),
          // ignore: missing_required_param
          BottomSheetAction(
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  //  color: Color.fromRGBO(243, 246, 255, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: textEditingControllerNewPassword,
                onFieldSubmitted: (_) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'search box is Empty';
                  }
                  return null;
                },
                style: TextStyle(
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                    ),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter New Password",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  icon: Icon(
                    Icons.vpn_key,
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                  ),
                ),
              ),
            ),
          ),
          // ignore: missing_required_param
          BottomSheetAction(
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  //  color: Color.fromRGBO(243, 246, 255, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: textEditingControllerConformNewPassword,
                onFieldSubmitted: (_) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'search box is Empty';
                  }
                  return null;
                },
                style: TextStyle(
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                    ),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm New Password",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  icon: Icon(
                    Icons.vpn_key,
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                  ),
                ),
              ),
            ),
          ),
        ],
        cancelAction: CancelAction(
          title: const Text('Save Change'),
          onPressed: () {
            Navigator.pop(context);
            _changePassword(
                context,
                textEditingControllerOldPassword.text,
                textEditingControllerNewPassword.text,
                textEditingControllerConformNewPassword.text);
          },
        ),
      );
    else
      return showAdaptiveActionSheet(
        context: context,
        title: const Text('Edit Profile'),
        // bottomSheetColor: Color.fromRGBO(226, 234, 246, 1),
        actions: <BottomSheetAction>[
          // ignore: missing_required_param
          BottomSheetAction(
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  //  color: Color.fromRGBO(243, 246, 255, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: textEditingControllerFName,
                onFieldSubmitted: (_) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'search box is Empty';
                  }
                  return null;
                },
                style: TextStyle(
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                    ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  icon: Icon(
                    Icons.person_rounded,
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                  ),
                ),
              ),
            ),
          ),
          // ignore: missing_required_param
          BottomSheetAction(
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  //  color: Color.fromRGBO(243, 246, 255, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: textEditingControllerSName,
                onFieldSubmitted: (_) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'search box is Empty';
                  }
                  return null;
                },
                style: TextStyle(
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                    ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  icon: Icon(
                    Icons.person_rounded,
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                  ),
                ),
              ),
            ),
          ),
          // ignore: missing_required_param
          BottomSheetAction(
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  //  color: Color.fromRGBO(243, 246, 255, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                enabled: false,
                controller: textEditingControllerEmail,
                onFieldSubmitted: (_) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'search box is Empty';
                  }
                  return null;
                },
                style: TextStyle(
                    //  color: Colors.grey[400],
                    ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.account_circle,
                    //  color: Color.fromRGBO(0, 82, 205, 1),
                  ),
                ),
              ),
            ),
          ),
        ],
        cancelAction: CancelAction(
          title: const Text('Update'),
          onPressed: () {
            _updateName(context);
            Navigator.pop(context);
          },
        ),
      );
  }

  name() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString("userAvatar") != "null") {
      setState(() {
        imageFound = true;
        imagePath = sharedPreferences.getString("userAvatar");
      });
    }
    List<dynamic> list = sharedPreferences.getStringList("firstSecond");
    email = sharedPreferences.getString("email");
    creationDate = sharedPreferences.getString("creationDate");
    createDataDay = creationDate.split('T')[0];
    createDataTime = creationDate.split('T')[1];
    // notifications = await GetsNumbers.getNotifiaction();
    setState(() {
      textEditingControllerFName.text = list[0];
      textEditingControllerSName.text = list[1];
      textEditingControllerEmail.text = email;
      fName = list[0];
      sName = list[1];
      imagePath = sharedPreferences.getString("userAvatar");
    });
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };

    try {
      var url = Uri.parse("${MyApp.url}/");
      final response = await http.get(
        url,
        headers: requestHeaders,
      );
      final jsonResponse = await json.decode(response.body);
      setState(() {
        workspaces = jsonResponse["assignedWorkspaces"].toString();
        tasks = jsonResponse["assignedTasks"].toString();
        notifications = jsonResponse["assignedNotification"];
      });
    } catch (e) {
      print(e);
    }
  }

  siginOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
    sharedPreferences.remove("firstSecond");
    sharedPreferences.remove("userAvatar");

    // sharedPreferences.clear();
    // ignore: deprecated_member_use
    // sharedPreferences.commit();
  }

  void evictImage(String url) {
    final NetworkImage provider = NetworkImage(url);
    if (!url.contains("null")) {
      provider.evict().then<void>((bool success) {
        if (success) debugPrint('removed image');
      });
    }
  }

  showsnakbar(var res, BuildContext context) async {
    var w = MediaQuery.of(context).size.width;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var snakbar;
    if (res["successful"] == true) {
      snakbar = SnackBar(
        duration: Duration(seconds: 5),
        content: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            "image is update it",
            style: TextStyle(
                color: Colors.grey[300],
                fontFamily: "CCB",
                fontSize: w > 400 ? 20 : 17),
          ),
          trailing: Icon(
            Icons.check,
            color: Colors.grey[300],
          ),
        ),
      );
      sharedPreferences.setString("userAvatar", res["data"]);
      evictImage(MyApp.url + res["data"]);
      setState(() {
        imagePath = res["data"];
      });
      if (sharedPreferences.getString("userAvatar") != "null") {
        setState(() {
          imageFound = true;
          imagePath = sharedPreferences.getString("userAvatar");
          name();
        });
      }
      // setState(() {
      //   var list = sharedPreferences.getStringList("firstSecond");
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => NavBar(list[0])));
      // });
    } else
      snakbar = SnackBar(
        duration: Duration(seconds: 5),
        content: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            "Error while updating image",
            style: TextStyle(
                color: Colors.yellowAccent,
                fontFamily: "CCB",
                fontSize: w > 400 ? 20 : 17),
          ),
          trailing: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        ),
      );
    scaffoldMessengerKey.currentState.showSnackBar(snakbar);
  }

  _showAlertDilog(BuildContext context, File _image) {
    return showDialog(
        context: context,
        builder: (contect) {
          return AlertDialog(
            title: Text("Changing Profile Image"),
            content: Text(
              "Are Sure You want to Change Profile image?",
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    image = _image;
                  });
                  uploadimage(context);
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

  _changePassword(BuildContext context, String oldPassword, String newPassword,
      String confirmPassword) async {
    var w = MediaQuery.of(context).size.width;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": pref.getString("token")
    };
    var response = null, jsonResponse = null;
    var url = Uri.parse("${MyApp.url}/user/password/reset");
    if (oldPassword != null && oldPassword.isNotEmpty) {
      if (newPassword == confirmPassword) {
        response = http.post(url,
            headers: requestHeaders,
            body: jsonEncode(<String, String>{
              "oldPassword": oldPassword,
              "newPassword": newPassword,
            }));
        jsonResponse = json.decode(response.body);

        if (jsonResponse["successful"]) {
          scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
              duration: Duration(seconds: 5),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Password is updated",
                    style: TextStyle(
                        //  color: Colors.white,
                        fontFamily: "RubikL",
                        fontSize: w > 400 ? 20 : 17),
                  ),
                  Icon(
                    Icons.check,
                    //  color: Colors.green,
                  ),
                ],
              )));
        }
        if (!jsonResponse["successful"]) {
          scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
              duration: Duration(seconds: 5),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    jsonResponse["message"],
                    style: TextStyle(
                        //  color: Colors.white,
                        fontFamily: "RubikL",
                        fontSize: w > 400 ? 20 : 17),
                  ),
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.yellow,
                  ),
                ],
              )));
        }
      } else {
        scaffoldMessengerKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Input password Error",
                  style: TextStyle(
                      //  color: Colors.white,
                      fontFamily: "RubikL",
                      fontSize: w > 400 ? 20 : 17),
                ),
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.yellow,
                ),
              ],
            ),
          ),
        );
      }
    } else {
      scaffoldMessengerKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Old password is plank",
                style: TextStyle(
                    //  color: Colors.white,
                    fontFamily: "RubikL",
                    fontSize: w > 400 ? 20 : 17),
              ),
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.yellow,
              ),
            ],
          ),
        ),
      );
    }
  }

  _updateName(BuildContext context) async {
    var response = null;
    var jsonResponse = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };

    if (textEditingControllerFName.text.isNotEmpty &&
        textEditingControllerSName.text.isNotEmpty) {
      var url = Uri.parse("${MyApp.url}/profile/edit");
      response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          <String, String>{
            "firstName": textEditingControllerFName.text,
            "secondName": textEditingControllerSName.text,
          },
        ),
      );
      jsonResponse = await json.decode(response.body);
      if (jsonResponse["successful"] == true) {
        await sharedPreferences.setStringList('firstSecond', [
          jsonResponse['data']['firstName'],
          jsonResponse['data']['secondName'],
        ]);

        scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              "your name will change after restart the app",
              style: TextStyle(
                  //  color: Colors.white,
                  fontFamily: "CCB",
                  fontSize: MediaQuery.of(context).size.width > 400 ? 16 : 13),
            ),
            trailing: Icon(
              Icons.check,
              //  color: Colors.green,
            ),
          ),
        ));
      } else {
        scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              jsonResponse["message"],
              style: TextStyle(
                  //  color: Colors.white,
                  fontFamily: "CCB",
                  fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 17),
            ),
            trailing: Icon(
              Icons.error_outline_rounded,
              //  color: Colors.yellow,
            ),
          ),
        ));
      }
    }
  }

  _removeimage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "token": sharedPreferences.getString("token")
    };

    var url = Uri.parse("${MyApp.url}/user/avatar");
    final response = await http.delete(
      url,
      headers: requestHeaders,
    );
    final jsonResponse = await json.decode(response.body);
    print(jsonResponse);
    setState(() {
      name();
      sharedPreferences.remove("userAvatar");
    });
    if (sharedPreferences.getString("userAvatar") != "null") {
      setState(() {
        imageFound = true;
        imagePath = sharedPreferences.getString("userAvatar");
        name();
      });
    } else {
      setState(() {
        imageFound = false;
      });
    }
  }
}
