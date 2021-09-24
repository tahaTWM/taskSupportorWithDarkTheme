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

  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color.fromRGBO(250, 250, 250, 2),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Typicons.th_large_outline,
            ),
            // ignore: deprecated_member_use
            title: Text(
              'Workspaces',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_active_outlined,
            ),
            // ignore: deprecated_member_use
            title: Text(
              'Notifications',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            // ignore: deprecated_member_use
            title: Text(
              'Profile',
            ),
          ),
        ],
        currentIndex: widget.selectedItem,
        onTap: (index) {
          pageController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),

      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            widget.selectedItem = index;
          });
        },
        children: contents,
      ),
    );
  }
}
