import 'package:app2/notification/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'profile/profile.dart';
import 'package:flutter/material.dart';
import './homePage/homepage.dart';

// ignore: must_be_immutable
class NavBar extends StatefulWidget {
  int selectedItem;
  NavBar(this.selectedItem);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // int _selectedItem = 2;
  List<Widget> contents = [];

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    contents.add(HomePage());
    contents.add(Notifications());
    contents.add(Profile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(250, 250, 250, 2),
      bottomNavigationBar: CustomBottomNavigationBar(
        iconList: [
          Typicons.th_large_outline,
          Icons.notifications_active_outlined,
          Icons.person_outline,
        ],
        textList: [
          "Workspaces",
          "Notifications",
          "Profile",
        ],
        onChange: (indx) {
          setState(() {
            widget.selectedItem = indx;
          });
        },
        defaultSelectedIndex: widget.selectedItem,
      ),
      body: Center(
        child: contents[widget.selectedItem],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;
  final List<String> textList;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
      @required this.iconList,
      @required this.textList,
      @required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];
  List<String> _textList = [];

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
    _textList = widget.textList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], _textList[i], i));
    }

    return Row(
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, String text, int index) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: width < 400 ? 50 : 60,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(20),
          //   topRight: Radius.circular(20),
          // ),
        ),
        width: MediaQuery.of(context).size.width / _iconList.length,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              // color: index == _selectedIndex
              //     ? Color.fromRGBO(0, 82, 205, 1)
              //     : Colors.grey,
              size: width < 400 ? 22 : 28,
            ),
            Text(
              text,
              style: TextStyle(
                  // color: index == _selectedIndex
                  //     ? Color.fromRGBO(0, 82, 205, 1)
                  //     : Colors.grey,
                  fontSize: width < 400 ? 14 : 18),
            ),
          ],
        ),
      ),
    );
  }
}
