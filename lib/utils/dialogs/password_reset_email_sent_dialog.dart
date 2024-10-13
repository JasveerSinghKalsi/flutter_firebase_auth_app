import 'package:flutter/material.dart';
import 'package:baseapp/utils/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'We have sent you a password reset link to your email. Please click on the link to reset your password and login to the app',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
