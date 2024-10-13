import 'package:flutter/material.dart';
import 'package:baseapp/utils/dialogs/generic_dialog.dart';

Future<bool> showSentVerifyEmailDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
          context: context,
          title: 'Verify Email',
          content:
              "We have sent you a verification email. Please click on the link to verify yourself and then login to the app",
          optionsBuilder: () => {
                'Back': false,
                'Go to Login': true,
              },
          blurBackground: true)
      .then(
    (value) => value ?? false,
  );
}
