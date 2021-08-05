import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_post/helper/HelperFunction.dart';
import 'package:users_post/models/ModelProvider.dart';
import 'package:users_post/modules/account/ScreenAccount.dart';
import 'package:users_post/modules/users/ScreenDisplayUsers.dart';
import 'package:users_post/theme/ThemeColor.dart';

class ScreenHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScreenHomeState();
}

class ScreenHomeState extends State<ScreenHome> {
  final List<Widget> pages = [
    ScreenDisplayUsers(),
    ScreenAccount(),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> exitApp() async {
    final provider = Provider.of<ModelProvider>(context, listen: false);
    if (provider.getCurrentIndex == 0) {
      HelperFunction.showCommonDialog(context,
          title: 'Confirmation',
          content: Text('Are you sure you want to exit app?'),
          positiveButton: () {
        exit(0);
      });
    } else {
      provider.setCurrentIndex = 0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Consumer<ModelProvider>(builder: (context, provider, index) {
              return pages[provider.getCurrentIndex];
            }),
          ),
          bottomNavigationBar: Consumer<ModelProvider>(
            builder: (context, provider, index) {
              return BottomNavigationBar(
                onTap: (index) {
                  provider.setCurrentIndex = index;
                },
                backgroundColor: Colors.white,
                // showUnselectedLabels: false,
                unselectedLabelStyle: TextStyle(color: ThemeColor.grey),
                selectedItemColor: ThemeColor.darkPink,
                currentIndex: provider.getCurrentIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(Icons.home),
                    label: 'Discover',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(Icons.person),
                    label: 'Account',
                  )
                ],
              );
            },
          )),
    );
  }
}
