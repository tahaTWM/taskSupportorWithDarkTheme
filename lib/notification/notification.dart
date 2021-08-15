import 'package:flutter/material.dart';

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
    for (int i = 0; i < 3; i++) list.add(ListItem<String>("item $i"));
  }

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Selection"),
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
        margin: EdgeInsets.symmetric(vertical: 4),
        color: list[index].isSelected
            ? Colors.grey[100].withOpacity(0.1)
            : Colors.transparent,
        child: ListTile(
          contentPadding:
              EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
          leading: Container(
            padding: EdgeInsets.all(14),
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
          title: Text(
            "name",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          subtitle: Text(
            "name2",
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Checkbox(
            value: list[index].isSelected,
            onChanged: (bool _value) {},
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class Notifications extends StatefulWidget {
//   @override
//   _NotificationsState createState() => _NotificationsState();
// }
//
// class _NotificationsState extends State<Notifications> {
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Color.fromRGBO(250, 250, 250, 2),
//         elevation: 0,
//         title: Text(
//           "Profile",
//           style: TextStyle(
//               //  color: Colors.black,
//               ),
//         ),
//         centerTitle: true,
//         actions: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 5),
//             margin: EdgeInsets.only(right: 10, top: 7, bottom: 2),
//             child: PopupMenuButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(15.0))),
//               icon: Icon(
//                 Icons.more_vert,
//                 size: width > 400 ? 30 : 20,
//                 //  color: Colors.blue,
//               ),
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                     value: 1,
//                     child: Text(
//                       "Make it as read",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontFamily: "RubicB",
//                       ),
//                     )),
//                 PopupMenuItem(
//                   value: 2,
//                   child: Text(
//                     "Clear all",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontFamily: "RubicB",
//                     ),
//                   ),
//                 ),
//               ],
//               onSelected: (item) {
//                 switch (item) {
//                   case 1:
//                     break;
//                   case 2:
//                     break;
//                 }
//               },
//             ),
//           )
//         ],
//         iconTheme: IconThemeData(
//           // color: Colors.blue,
//           size: 28,
//         ),
//       ),
//       body: Container(
//           child: ListView.builder(
//         itemCount: 20,
//         itemBuilder: (BuildContext context, int index) {
//           return index != 3
//               ? Column(
//                   children: [
//                     ListTile(
//                         contentPadding: EdgeInsets.only(
//                             bottom: 5, left: 10, right: 10, top: 5),
//                         leading: Container(
//                           padding: EdgeInsets.all(14),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               width: 2,
//                               color: Color.fromRGBO(46, 204, 113, 1),
//                             ),
//                             color: Colors.grey.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text("test"),
//                         ),
//                         title: Text(
//                           "name",
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                         subtitle: Text(
//                           "name2",
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         trailing: Text("time")),
//                     Divider(
//                       //  color:Colors.black,
//                       thickness: 1,
//                       indent: 50,
//                       endIndent: 50,
//                     )
//                   ],
//                 )
//               : Column(
//                   children: [
//                     ListTile(
//                         contentPadding: EdgeInsets.only(
//                             bottom: 5, left: 10, right: 10, top: 5),
//                         leading: Container(
//                           padding: EdgeInsets.all(14),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               width: 2,
//                               color: Color.fromRGBO(46, 204, 113, 1),
//                             ),
//                             color: Colors.grey.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text("test"),
//                         ),
//                         title: Text(
//                           "Accept Your invite",
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               ButtonTheme(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 4.0, horizontal: 8.0),
//                                 //adds padding inside the button
//                                 materialTapTargetSize:
//                                     MaterialTapTargetSize.shrinkWrap,
//                                 //limits the touch area to the button area
//                                 minWidth: 0,
//                                 //wraps child's width
//                                 height: 0,
//                                 //wraps child's height
//                                 child: RaisedButton(
//                                     onPressed: () {},
//                                     child: Text('Accept')), //your original button
//                               ),
//                               SizedBox(width: 10),
//                               ButtonTheme(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 4.0, horizontal: 8.0),
//                                 //adds padding inside the button
//                                 materialTapTargetSize:
//                                     MaterialTapTargetSize.shrinkWrap,
//                                 //limits the touch area to the button area
//                                 minWidth: 0,
//                                 //wraps child's width
//                                 height: 0,
//                                 //wraps child's height
//                                 child: RaisedButton(
//                                     onPressed: () {},
//                                     child: Text('Deny')), //your original button
//                               ),
//                             ],
//                           ),
//                         ),trailing: Text("time")),
//                     Divider(
//                       //  color:Colors.black,
//                       thickness: 1,
//                       indent: 50,
//                       endIndent: 50,
//                     )
//                   ],
//                 );
//         },
//       )),
//     );
//   }
// }
