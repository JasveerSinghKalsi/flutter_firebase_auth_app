import 'package:baseapp/services/bloc/auth_bloc.dart';
import 'package:baseapp/services/bloc/auth_event.dart';
import 'package:baseapp/services/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/theme/palette.dart';
import 'package:baseapp/utils/dialogs/error_dialog.dart';
import 'package:baseapp/utils/dialogs/password_reset_email_sent_dialog.dart';
import 'package:baseapp/utils/widgets/auth_text_field.dart';
import 'package:baseapp/utils/widgets/gradient_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _email.clear();
            await showPasswordResetSentDialog(context);
          } else if (state.exception != null) {
            await showErrorDialog(
                context, 'We could not process your request.');
          }
        }
      },
      child: Scaffold(
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
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
