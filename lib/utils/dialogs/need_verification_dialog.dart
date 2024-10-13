import 'package:flutter/material.dart';
import 'package:baseapp/utils/dialogs/generic_dialog.dart';

Future<bool> showNeedVerficationDialog(BuildContext context) {
  return showGenericDialog<bool>(
          context: context,
          title: 'Account Not Verified',
          content:
              "The account has not been verified yet. Please check your inbox for the verification link.\nIf you have not received the emailyet, press 'Resend email' to receive email again",
          optionsBuilder: () => {
                'Back': false,
                'Resend email': true,
              },
          blurBackground: true)
      .then(
    (value) => value ?? false,
  );
}
