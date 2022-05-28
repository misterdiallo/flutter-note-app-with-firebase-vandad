import 'package:flutter/material.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog<T>({
  required BuildContext context,
  required String text,
}) {
  return showGenericDialog<void>(
    context: context,
    title: "Oups..!",
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
