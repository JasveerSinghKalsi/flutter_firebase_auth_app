import 'package:baseapp/constants/routes.dart';
import 'package:baseapp/services/auth/auth_service.dart';
import 'package:baseapp/views/app/app_view.dart';
import 'package:baseapp/views/sign/create_account_view.dart';
import 'package:baseapp/views/sign/forgot_password_view.dart';
import 'package:baseapp/views/sign/login_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Base App',
    theme: ThemeData.dark(
      useMaterial3: true,
    ).copyWith(
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
    ),
    home: const HomePage(),
    routes: {
      loginViewRoute: (context) => const LoginView(),
      createAccountViewRoute: (context) => const CreateAccountView(),
      forgotPasswordViewRoute: (context) => const ForgotPasswordView(),
      appViewRoute: (context) => const AppView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null && user.isEmailVerified) {
              return const AppView();
            } else {
              return const LoginView();
            }
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
