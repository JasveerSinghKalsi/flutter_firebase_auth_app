import 'package:flutter/material.dart';
import 'package:baseapp/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'Error',
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
