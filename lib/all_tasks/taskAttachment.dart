import 'dart:convert';
import 'dart:io';
import 'package:unicorndial/unicorndial.dart';

import './pdeView.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

// ignore: must_be_immutable
class Attachment extends StatefulWidget {
  int taskID;
  String prority;
  Attachment(this.taskID, this.prority);

  @override
  _AttachmentState createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  bool upload = false;
  var list = [];
  double percent = 0.0;
  File image;
  File file;
  List res = [];
  String token = '';
  bool attachmentFound = false;
  int time = 10;
  @override
  void initState() {
    checkIfThereAnyAttachment();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    var childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "File",
        currentButton: FloatingActionButton(
          elevation: 12,
          heroTag: "train",
          backgroundColor: Colors.green,
          mini: true,
          child: Icon(Icons.insert_drive_file),
          onPressed: () async {
            FilePickerResult result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (result != null) {
              File file2 = File(result.files.single.path);
              uploadimage(context, file2);
              // _confromUploadImageOrFile(context, file2);
              // if (result.files.single.path != null) {
              //   scaffoldMessengerKey.currentState.showSnackBar(
              //     SnackBar(
              //       backgroundColor: Colors.grey[700],
              //       action: SnackBarAction(
              //         label: "Yes",
              //         onPressed: () => uploadimage(context, file2),
              //       ),
              //       duration: Duration(seconds: time),
              //       content: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "Confirm to upload this Attachment?",
              //             maxLines: 3,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //           ButtonTheme(
              //             padding:
              //                 EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              //             materialTapTargetSize:
              //                 MaterialTapTargetSize.shrinkWrap,
              //             minWidth: 0,
              //             height: 0,
              //             // ignore: deprecated_member_use
              //             child: FlatButton(
              //                 shape: new RoundedRectangleBorder(
              //                   borderRadius: new BorderRadius.circular(10),
              //                 ),
              //                 onPressed: () => scaffoldMessengerKey.currentState
              //                     .clearSnackBars(),
              //                 child: Text('No')), //your original button
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
              // }
            }
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        labelText: "Camera",
        hasLabel: true,
        currentButton: FloatingActionButton(
          elevation: 12,
          heroTag: "airplane",
          backgroundColor: Colors.pinkAccent,
          mini: true,
          child: Icon(Icons.image_rounded),
          onPressed: () {
            _showPicker(context);
          },
        ),
      ),
    );
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Attachments",
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                //  color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.symmetric(horizontal: 2),
              margin: EdgeInsets.only(right: 10, top: 7),
              child: PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                icon: Icon(
                  Icons.more_vert,
                  size: 26,
                  //  color: Colors.blue,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.paperclip,
                          size: 30,
                          ////  color: Color.fromRGBO(158, 158, 158, 1),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Add Attachment",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "RubicB",
                          ),
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          size: 30,
                          //  color: Color.fromRGBO(158, 158, 158, 1),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "RubicB",
                          ),
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh,
                          size: 30,
                          //  color: Color.fromRGBO(158, 158, 158, 1),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Refresh",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "RubicB",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                onSelected: (item) {
                  switch (item) {
                    case 1:
                      {
                        _showPickerFileOrImage(context);
                      }
                      break;
                    case 2:
                      {
                        setState(() {
                          upload = true;
                        });
                      }

                      break;
                    case 3:
                      {
                        checkIfThereAnyAttachment();
                      }

                      break;
                  }
                },
              ),
            )
          ],
          iconTheme: IconThemeData(
            //  color: Colors.blue,
            size: 28,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: attachmentFound == false
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : res != null
                  ? RefreshIndicator(
                      onRefresh: checkIfThereAnyAttachment,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          var url = "${MyApp.url}${res[index]["user_avatar"]}";
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.only(
                                    bottom: 5, left: 10, right: 10, top: 5),
                                onLongPress: () {
                                  // print(res[index]["id"].toString() + "\n");
                                  // print(
                                  //     res[index]["path"].toString().split('/')[5]);
                                  _confirmDelete(
                                      context,
                                      res[index]["id"],
                                      int.parse(res[index]["path"]
                                          .toString()
                                          .split('/')[5]));
                                },
                                leading: url.contains('null') ||
                                        res[index]["user_avatar"] == null ||
                                        res[index]["user_avatar"] == "null"
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
                                        child: Text(res[index]["firstName"][0]
                                            .toString()
                                            .toUpperCase()),
                                      )
                                    : ClipOval(
                                        child: Image.network(
                                          url,
                                          height: 53,
                                          width: 53,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                title: Text(
                                  res[index]["firstName"] +
                                      " " +
                                      res[index]["secondName"],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                subtitle: Text(
                                  res[index]["name"],
                                ),
                                // subtitle: Image.network("${MyApp.url}${res[index]["path"]}"),
                                // overflow: TextOverflow.ellipsis,
                                // ),
                                trailing: res[index]["attachment_type"] ==
                                        "IMAGE"
                                    ? InkWell(
                                        onTap: () => showDialog(
                                            context: context,
                                            builder: (_) => ImageDialog(
                                                "${MyApp.url}${res[index]["path"]}?token=${token.toString()}")),
                                        child: Image.network(
                                          "${MyApp.url}${res[index]["path"]}?token=${token.toString()}",
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          final url =
                                              "${MyApp.url}${res[index]["path"]}?token=${token.toString()}";
                                          final file = await loadNetwork(
                                            url,
                                          );
                                          openPDF(context, file);
                                        },
                                        icon: Icon(CupertinoIcons.paperclip),
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
                        itemCount: res.length,
                      ),
                    )
                  : Center(
                      child: Text(
                        "No Attachment add yet",
                        style: TextStyle(
                            fontFamily: "RubikL",
                            fontSize: MediaQuery.of(context).size.width < 400
                                ? 23
                                : 28),
                      ),
                    ),
        ),
        floatingActionButton: UnicornDialer(
            hasNotch: false,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(
              Icons.add,
            ),
            childButtons: childButtons),

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _showPickerFileOrImage(context),
        //   child: Icon(Icons.add),
        // ),
      ),
    );
  }

  //this function to add attachment to task
  //image picker
  //select betwen camera and storage

  _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
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
                ],
              ),
            ),
          );
        });
  }

  // for display attachment
  // displayBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       elevation: 0,
  //       context: context,
  //       builder: (ctx) {
  //         return Container(
  //           //  color: Color(0xFF737373),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               //  color: Colors.red,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(30),
  //                 topRight: Radius.circular(30),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 40),
  //               child: Text(
  //                 "Welcome to AndroidVille!",
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  _showPickerFileOrImage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.insert_drive_file),
                      title: new Text('File'),
                      onTap: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          File file2 = File(result.files.single.path);
                          // _confromUploadImageOrFile(context, file2);
                          if (result.files.single.path != null) {
                            scaffoldMessengerKey.currentState.showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.grey[700],
                                action: SnackBarAction(
                                  label: "Yes",
                                  onPressed: () => uploadimage(context, file2),
                                ),
                                duration: Duration(seconds: time),
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Confirm to upload this Attachment?",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    ButtonTheme(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minWidth: 0,
                                      height: 0,
                                      // ignore: deprecated_member_use
                                      child: FlatButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10),
                                          ),
                                          onPressed: () => scaffoldMessengerKey
                                              .currentState
                                              .clearSnackBars(),
                                          child: Text(
                                              'No')), //your original button
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.image),
                    title: new Text('Image'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showPicker(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery(BuildContext context) async {
    // ignore: invalid_use_of_visible_for_testing_member
    var image = (await ImagePicker.platform.getImage(
      source: ImageSource.gallery,
    ));
    if (image != null) {
      final File _image = File(image.path);
      print(_image);
      uploadimage(context, _image);
      // _confromUploadImageOrFile(context, _image);
    }
  }

  _imgFromCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    // ignore: invalid_use_of_visible_for_testing_member
    var image = (await ImagePicker.platform.getImage(
      source: ImageSource.camera,
    ));
    if (image != null) {
      final File _image = File(image.path);
      if (_image != null) uploadimage(context, _image);
      // _confromUploadImageOrFile(context, _image);
    }
  }

  _confromUploadImageOrFile(BuildContext context, File file1) {
    return showDialog(
        context: context,
        builder: (contect) {
          return AlertDialog(
            title: Text("Upload Attachment"),
            content: Text(
              "Are Sure You want to upload this Attachment?",
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  uploadimage(context, file1);
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

  uploadimage(BuildContext context, File _file) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (_file != null) {
      var fileType = lookupMimeType(_file.path);
      // if (fileType.split('/')[0] == "image") {
      var imageBytes = _file.readAsBytesSync();
      var request = http.MultipartRequest("POST",
          Uri.parse("${MyApp.url}/workspace/task/${widget.taskID}/attachment"));
      request.files.add(
        http.MultipartFile.fromBytes(
          "taskAttachment",
          imageBytes,
          filename: basename(_file.path),
          contentType:
              MediaType(fileType.split('/')[0], fileType.split('/')[1]),
        ),
      );
      request.headers.addAll({"token": sharedPreferences.getString("token")});
      final response = await request.send();
      final resSTR = await response.stream.bytesToString();
      var jsonRespnse = jsonDecode(resSTR);
      if (jsonRespnse["successful"] == true) {
        setState(() {
          checkIfThereAnyAttachment();
        });
      }
      // }else{

      // }
    }
  }

  Future<void> checkIfThereAnyAttachment() async {
    var jsonResponse;
    List<dynamic> _res = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      'token': sharedPreferences.getString("token"),
    };
    setState(() {
      token = sharedPreferences.getString("token");
    });
    var url =
        Uri.parse('${MyApp.url}/workspace/task/${widget.taskID}/attachment');
    var response = await http.get(
      url,
      headers: requestHeaders,
    );

    jsonResponse = json.decode(response.body);
    // print(jsonResponse);
    if (jsonResponse["successful"]) {
      setState(() {
        attachmentFound = true;
        _res = jsonResponse["data"];
        if (_res != null) {
          List<dynamic> resREV = _res.reversed.toList();
          res = resREV;
        } else {
          res = null;
        }
      });
    }
    if (!jsonResponse["successful"]) {
      print("error");
    }
  }

  _deleteAttachment(int id, int folderID) async {
    var jsonResponse = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      'token': sharedPreferences.getString("token"),
    };
    var url = Uri.parse(
        '${MyApp.url}/workspace/task/${widget.taskID}/attachment/$id/$folderID');
    var response = await http.delete(
      url,
      headers: requestHeaders,
    );

    jsonResponse = json.decode(response.body);
    print(jsonResponse);
    if (jsonResponse["successful"]) {
      setState(() {
        checkIfThereAnyAttachment();
      });
    }
    if (!jsonResponse["successful"]) {
      print("error");
    }
  }

  _confirmDelete(BuildContext context, int id, int folderID) {
    return showDialog(
        context: context,
        builder: (contect) {
          return AlertDialog(
            title: Text("Deleting Attachment"),
            content: Text(
              "Are you sure to Delete this Attachment?",
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _deleteAttachment(id, folderID);
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

  Future<File> loadNetwork(String _url) async {
    var _uri = Uri.parse(_url);
    final response = await http.get(_uri);
    final bytes = response.bodyBytes;

    //save file
    final filename = basename(_url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}

class ImageDialog extends StatelessWidget {
  String url;

  ImageDialog(this.url);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // elevation: 0,
      child: Image.network(
        url,
        fit: BoxFit.contain,
      ),
    );
  }
}
