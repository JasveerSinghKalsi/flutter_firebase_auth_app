import 'package:flutter/material.dart';
import 'package:baseapp/services/auth/auth_exceptions.dart';
import 'package:baseapp/services/auth/auth_service.dart';
import 'package:baseapp/constants/routes.dart';
import 'package:baseapp/theme/palette.dart';
import 'package:baseapp/utils/dialogs/error_dialog.dart';
import 'package:baseapp/utils/dialogs/need_verification_dialog.dart';
import 'package:baseapp/utils/widgets/auth_text_field.dart';
import 'package:baseapp/utils/widgets/gradient_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              AuthTextField(
                controller: _email,
                hintText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              AuthTextField(
                controller: _password,
                hintText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Login',
                gradientColors: const [
                  Palette.gradient1,
                  Palette.gradient2,
                  Palette.gradient3
                ],
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    await AuthService.firebase().login(
                      email: email,
                      password: password,
                    );
                    final user = AuthService.firebase().currentUser;
                    if (context.mounted) {
                      if (user?.isEmailVerified ?? false) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            appViewRoute, (route) => false);
                      } else {
                        final shouldResendVerifyEmail =
                            await showNeedVerficationDialog(context);
                        if (shouldResendVerifyEmail) {
                          AuthService.firebase().sendEmailverification();
                        } else {
                          AuthService.firebase().logout();
                        }
                      }
                    }
                  } on InvalidCredentialsAuthException {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Invalid Credentials');
                    }
                  } on GenericAuthException {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Authentication Error');
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      forgotPasswordViewRoute, (route) => false);
                },
                child: const Text('Forgot Password'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not registered yet?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          createAccountViewRoute, (route) => false);
                    },
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
