import 'package:baseapp/utils/dialogs/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:baseapp/constants/routes.dart';
import 'package:baseapp/theme/palette.dart';
import 'package:baseapp/utils/dialogs/need_verification_dialog.dart';
import 'package:baseapp/utils/widgets/auth_text_field.dart';
import 'package:baseapp/utils/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

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
                prefixIcon: Icons.email,
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
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    final user = FirebaseAuth.instance.currentUser;
                    if (context.mounted) {
                      if (user?.emailVerified ?? false) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            appViewRoute, (route) => false);
                      } else {
                        final shouldResendVerifyEmail =
                            await showNeedVerficationDialog(context);
                        if (shouldResendVerifyEmail) {
                          user?.sendEmailVerification();
                        } else {
                          FirebaseAuth.instance.signOut();
                        }
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    if (context.mounted) {
                      switch (e.code) {
                        case 'invalid-credential':
                          await showErrorDialog(
                              context, 'Invalid Crendentials');
                        default:
                          await showErrorDialog(context, 'Error: ${e.code}');
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      await showErrorDialog(context, e.toString());
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
