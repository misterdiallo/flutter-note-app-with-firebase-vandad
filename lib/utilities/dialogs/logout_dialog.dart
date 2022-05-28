import 'package:flutter/material.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog<T>({
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: "Sign Out",
    content: "Are you sure you want to Sign out ?",
    optionsBuilder: () => {
      'Cancel': false,
      'Sign Out': true,
    },
  ).then((value) => value ?? false);
}
