import 'package:baseapp/services/auth/auth_exceptions.dart';
import 'package:baseapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/constants/routes.dart';
import 'package:baseapp/theme/palette.dart';
import 'package:baseapp/utils/dialogs/error_dialog.dart';
import 'package:baseapp/utils/dialogs/password_reset_email_sent_dialog.dart';
import 'package:baseapp/utils/widgets/auth_text_field.dart';
import 'package:baseapp/utils/widgets/gradient_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                    'If you have forgot your password, enter your email and then a password reset link will be shared to your registered email account',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              AuthTextField(
                controller: _email,
                hintText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              GradientButton(
                  text: 'Send password reset email',
                  gradientColors: const [
                    Palette.gradient1,
                    Palette.gradient2,
                    Palette.gradient3,
                  ],
                  onPressed: () async {
                    final email = _email.text;
                    if (email.isEmpty) {
                      return showErrorDialog(
                        context,
                        'Email not entered',
                      );
                    } else {
                      try {
                        await AuthService.firebase()
                            .sendPasswordReset(email: email);
                        if (context.mounted) {
                          await showPasswordResetSentDialog(context);
                        }
                      } on InvalidEmailAuthException {
                        if (context.mounted) {
                          await showErrorDialog(context, 'Invalid Email');
                        }
                      } on GenericAuthException {
                        if (context.mounted) {
                          await showErrorDialog(context, 'An error occured');
                        }
                      }
                    }
                  }),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      loginViewRoute, (route) => false);
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
