import 'package:baseapp/services/bloc/auth_bloc.dart';
import 'package:baseapp/services/bloc/auth_event.dart';
import 'package:baseapp/services/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/services/auth/auth_exceptions.dart';
import 'package:baseapp/theme/palette.dart';
import 'package:baseapp/utils/dialogs/error_dialog.dart';
import 'package:baseapp/utils/dialogs/sent_verify_email.dart';
import 'package:baseapp/utils/widgets/auth_text_field.dart';
import 'package:baseapp/utils/widgets/gradient_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateCreatingAccount) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to create account');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 40),
                const Text('Get Started',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 40),
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
                    Palette.gradient3,
                  ],
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(AuthEventCreateAccount(
                          email: email,
                          password: password,
                        ));
                    final shouldGoToLogin =
                        await showSentVerifyEmailDialog(context);
                    if (shouldGoToLogin && context.mounted) {
                      context.read<AuthBloc>().add(const AuthEventLogout());
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
                          context.read<AuthBloc>().add(const AuthEventLogout());
                        },
                        child: const Text('Login')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
