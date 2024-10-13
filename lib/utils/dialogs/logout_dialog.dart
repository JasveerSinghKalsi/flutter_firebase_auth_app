import 'package:flutter/material.dart';
import 'package:baseapp/utils/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionsBuilder: () => {
      'Cancel': false,
      'Logout': true,
    },
    optionsColor: {
      'Logout': Colors.red[700],
    },
  ).then(
    (value) => value ?? false,
  );
}
