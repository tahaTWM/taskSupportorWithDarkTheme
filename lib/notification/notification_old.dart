import 'package:flutter/material.dart';

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}

class Notifications_OLD extends StatefulWidget {
  @override
  _Notifications_OLDState createState() => _Notifications_OLDState();
}

class _Notifications_OLDState extends State<Notifications_OLD> {
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
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Notifications_OLD",
          style: TextStyle(
              //  color: Colors.black,
              ),
        ),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
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
                          list[i].isSelected = !list[i].isSelected;
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
    return GestureDetector(
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
        margin: EdgeInsets.symmetric(vertical: 8),
        color: list[index].isSelected
            ? Colors.grey[100].withOpacity(0.1)
            : Colors.transparent,
        child: ListTile(
          focusColor: Colors.white,
          contentPadding:
              EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
          leading: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Color.fromRGBO(46, 204, 113, 1),
              ),
              color: Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text("test"),
          ),
          title: index % 2 == 0
              ? Text(
                  "Unknow Sent you invite to workSpace MSMAR",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                )
              : Text(
                  "Taha",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
          subtitle: index % 2 == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonTheme(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          minWidth: 0,
                          height: 0,
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10),
                              ),
                              onPressed: () {},
                              child: Text('Accept')), //your original button
                        ),
                        SizedBox(width: 10),
                        ButtonTheme(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          //adds padding inside the button
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          //limits the touch area to the button area
                          minWidth: 0,
                          //wraps child's width
                          height: 0,
                          //wraps child's height
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10),
                              ),
                              onPressed: () {},
                              child: Text('Deny')), //your original button
                        ),
                      ],
                    ),
                  ),
                )
              : Text(
                  "name2",
                  overflow: TextOverflow.ellipsis,
                ),
          trailing: Text(DateTime.now().toString().split(' ')[0]),
        ),
      ),
    );
  }
}
