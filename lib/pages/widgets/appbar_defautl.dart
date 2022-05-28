import 'package:flutter/material.dart';

AppBar appBarDefault(
    BuildContext context, String title, List<Widget>? actions) {
  return AppBar(
    // leading: const BackButton(),
    // backgroundColor: active,
    title: Text(title),
    centerTitle: true,
    elevation: 3,
    actions: actions,
  );
}
