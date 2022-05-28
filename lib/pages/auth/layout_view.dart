import 'package:flutter/material.dart';

class LayoutView extends StatelessWidget {
  var widget;
  LayoutView({
    Key? key,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: widget,
    );
  }
}
