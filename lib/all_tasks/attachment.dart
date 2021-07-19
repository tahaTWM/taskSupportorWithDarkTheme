import 'dart:convert';
import 'dart:io';
import 'package:app2/all_tasks/pdeView.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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
  @override
  void initState() {
    checkIfThereAnyAttachment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromRGBO(243, 246, 255, 1),
        appBar: AppBar(
          // backgroundColor: Color.fromRGBO(243, 246, 255, 1),
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
          child: res != null
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    var url = "${MyApp.url}${res[index]["user_avatar"]}";
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(
                              bottom: 5, left: 10, right: 10, top: 5),
                          onLongPress: () {
                            print(res[index]["id"].toString() + "\n");
                            print(res[index]["path"].toString().split('/')[3]);
                            _confirmDelete(
                                context,
                                res[index]["id"],
                                int.parse(res[index]["path"]
                                    .toString()
                                    .split('/')[3]));
                          },
                          leading: url.split(':')[2].toString().contains('null')
                              ? Container(
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
                                  child: Text(res[index]["firstName"][0]
                                      .toString()
                                      .toUpperCase()),
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(url),
                                      fit: BoxFit.contain,
                                    ),
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
                          trailing: res[index]["attachment_type"] == "IMAGE"
                              ? InkWell(
                                  onTap: () => showDialog(
                                      context: context,
                                      builder: (_) => ImageDialog(
                                          "${MyApp.url}${res[index]["path"]}")),
                                  child: Image.network(
                                      "${MyApp.url}${res[index]["path"]}"),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    final url =
                                        "${MyApp.url}${res[index]["path"]}";
                                    final file = await loadNetwork(url);
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
                )
              : Center(
                  child: Text("No Attachment Found"),
                ),
        ));
  }

  //this function to add attachment to task
  //image picker
  //select betwen camera and storage

  _showPicker(context) async {
    await Permission.storage.request();
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
  displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        elevation: 0,
        context: context,
        builder: (ctx) {
          return Container(
            //  color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                //  color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  "Welcome to AndroidVille!",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        });
  }

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
                          allowedExtensions: ['pdf', 'doc', 'docx'],
                        );

                        if (result != null) {
                          File file2 = File(result.files.single.path);
                          _confromUploadImageOrFile(context, file2);
                          // uploadimage(context, file2);
                        }
                        // FilePickerResult file2 =
                        //     await FilePicker.platform.pickFiles(
                        //   type: FileType.custom,
                        //   allowedExtensions: ['jpg', 'pdf', 'doc'],
                        // );
                        // print(file2.paths.toString());

                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.image),
                    title: new Text('Image'),
                    onTap: () {
                      _showPicker(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    var _image = (await ImagePicker.pickImage(
      source: ImageSource.gallery,
    ));
    if (_image != null) _confromUploadImageOrFile(context, _image);
  }

  _imgFromCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    var _image = (await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50));
    if (_image != null) _confromUploadImageOrFile(context, _image);
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

  checkIfThereAnyAttachment() async {
    var jsonResponse = null;
    List<dynamic> _res = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      'token': sharedPreferences.getString("token"),
    };
    var url =
        Uri.parse('${MyApp.url}/workspace/task/${widget.taskID}/attachment');
    var response = await http.get(
      url,
      headers: requestHeaders,
    );

    jsonResponse = json.decode(response.body);
    if (jsonResponse["successful"]) {
      setState(() {
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
