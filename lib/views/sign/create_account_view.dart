import 'package:flutter/material.dart';
import 'package:baseapp/constants/routes.dart';
import 'package:baseapp/services/auth/auth_exceptions.dart';
import 'package:baseapp/services/auth/auth_service.dart';
import 'package:baseapp/theme/palette.dart';
import 'package:baseapp/utils/dialogs/error_dialog.dart';
import 'package:baseapp/utils/dialogs/sent_verify_email.dart';
import 'package:baseapp/utils/widgets/auth_text_field.dart';
import 'package:baseapp/utils/widgets/gradient_button.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  bool _isPasswordMatched = false;

  void _checkPasswordMatch() {
    setState(() {
      _isPasswordMatched = _password.text == _confirmPassword.text;
    });
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    _password.addListener(_checkPasswordMatch);
    _confirmPassword.addListener(_checkPasswordMatch);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Get Started',
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
              AuthTextField(
                controller: _confirmPassword,
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: _isPasswordMatched && _password.text.isNotEmpty
                    ? const Icon(
                        Icons.check,
                        color: Colors.greenAccent,
                      )
                    : null,
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Create Account',
                gradientColors: const [
                  Palette.gradient1,
                  Palette.gradient2,
                  Palette.gradient3
                ],
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    if (!_isPasswordMatched) {
                      showErrorDialog(context, 'The passwords does not match');
                    } else {
                      await AuthService.firebase().createUser(
                        email: email,
                        password: password,
                      );
                      await AuthService.firebase().sendEmailverification();
                      if (context.mounted) {
                        final shouldGoToLogin =
                            await showSentVerifyEmailDialog(context);
                        if (shouldGoToLogin && context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginViewRoute, (route) => false);
                        }
                      }
                    }
                  } on WeakPasswordAuthException {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Weak Password');
                    }
                  } on EmailAlreadyInUseAuthException {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Email is already in use');
                    }
                  } on InvalidEmailAuthException {
                    if (context.mounted) {
                      await showErrorDialog(context, 'Invalid email');
                    }
                  } on GenericAuthException {
                    if (context.mounted) {
                      await showErrorDialog(
                          context, 'Failed to create account');
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already registered?'),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginViewRoute, (route) => false);
                      },
                      child: const Text('Login')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
