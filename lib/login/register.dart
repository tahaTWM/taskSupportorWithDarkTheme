import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'logn.dart';

class Register extends StatefulWidget {
  static String fName;

  @override
  State<StatefulWidget> createState() {
    return new _Register();
  }
}

class _Register extends State<Register> {
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _secondName = new TextEditingController();
  final TextEditingController _eMail = new TextEditingController();
  final TextEditingController _passWord = new TextEditingController();
  final TextEditingController _confPassword = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var padding = EdgeInsets.only(top: 5, bottom: 5);
    return Form(
      key: _formKey,
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          // backgroundColor: Color.fromRGBO(243, 246, 255, 1),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 15, 25, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: w > 400 ? 30 : 10),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image(
                        width: w > 400 ? 150 : 90,
                        height: w > 400 ? 150 : 90,
                        image: AssetImage("asset/newLogo3.png"),
                      ),
                    )),
                  ),
                  SizedBox(height: 5),
                  Center(
                      child: Text(
                    "Ur Tasks",
                    style: TextStyle(
                      fontSize: w > 400 ? 35 : 25,
                      // color: Color.fromRGBO(62, 128, 255, 1),
                    ),
                  )),
                  SizedBox(height: 20),
                  // lebel(padding, "First Name"),
                  textField(_firstName, false, "First Name", false),
                  SizedBox(height: 20),
                  // lebel(padding, "Second Name"),
                  textField(_secondName, false, "Second Name", false),
                  SizedBox(height: 20),
                  // lebel(padding, "Email"),
                  textField(_eMail, false, "Email", true),
                  SizedBox(height: 20),
                  // lebel(padding, 'Password'),
                  textField(_passWord, true, "Password", false),
                  SizedBox(height: 20),
                  // lebel(padding, 'Confirm Password'),
                  textField(_confPassword, true, "Confirm Password", false),

                  SizedBox(height: 15),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              signUp(_firstName.text, _secondName.text,
                                  _eMail.text, _passWord.text);
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: "Rubik",
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.grey[600],
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Back to LogIn",
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: "Rubik",
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(
    TextEditingController controller,
    bool obscure,
    String hint,
    bool email,
  ) {
    var w = MediaQuery.of(context).size.width;
    return TextFormField(
      style: TextStyle(
        fontSize: w < 400 ? 19 : 24,
        fontFamily: "Rubik",
        // color: Colors.black,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: new BorderSide(color: Colors.black),
          ),
          hintText: hint),
      controller: controller,
      obscureText: obscure,
      maxLength: obscure == true ? 16 : null,
      keyboardType: email == true ? TextInputType.emailAddress : null,
    );
  }

  Map<String, String> requestHeaders = {
    "Content-type": "application/json; charset=UTF-8",
  };

  signUp(String firstName, String secondName, String email,
      String password) async {
    // ignore: avoid_init_to_null
    var jsonResponse = null;
    var response;
    var url = Uri.parse("${MyApp.url}/user/register");

    if (_passWord.text == _confPassword.text) {
      response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          <String, String>{
            "firstName": firstName,
            "secondName": secondName,
            "email": email,
            "password": password
          },
        ),
      );
      jsonResponse = json.decode(response.body);
      if (!jsonResponse["successful"]) {
        showsnakbar(
          jsonResponse["message"],
        );
      }
      if (jsonResponse["successful"]) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Logn()));
      }
    } else {
      scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.yellow),
              SizedBox(width: 10),
              Text(
                "Password does not match",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          )));
    }
  }

  showsnakbar(String msg) {
    var snakbar;
    if (msg == null)
      snakbar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          msg.contains(',')
              ? "${msg.split(',')[0]}'\n'${msg.split(',')[1]}"
              : msg,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      );
    else
      snakbar = SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.yellow),
              SizedBox(width: 10),
              Text(
                msg.contains(',')
                    ? "${msg.split(',')[0]}'\n'${msg.split(',')[1]}"
                    : msg,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ));
    scaffoldMessengerKey.currentState.showSnackBar(snakbar);
  }
}
