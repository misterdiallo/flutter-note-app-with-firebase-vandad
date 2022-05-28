import 'package:flutter/material.dart';
import 'package:my_notes/enums/menu_action.dart';
import 'package:my_notes/pages/widgets/appbar_defautl.dart';
import 'dart:developer' as devtools;

import 'package:my_notes/utilities/dialogs/logout_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devtools.log("Hello");
    return Scaffold(
      appBar: appBarDefault(
        context,
        "Home",
        [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  await showLogoutDialog(context: context);
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Sign Out'),
                )
              ];
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // user.displayName != null
          //     ? Center(
          //         child: Text(
          //           user.displayName.toString(),
          //           style: Theme.of(context).textTheme.headline6,
          //         ),
          //       )
          //     : const SizedBox(),
          // user.displayName != null
          //     ? const SizedBox(
          //         height: 15,
          //       )
          //     : const SizedBox(),
          Center(
            child: Text(
              "Welcome to ",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: Text(
              "let's start coding!",
              style: Theme.of(context).textTheme.overline,
            ),
          ),
        ],
      ),
    );
  }
}
