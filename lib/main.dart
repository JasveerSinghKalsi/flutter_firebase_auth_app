import 'package:baseapp/constants/routes.dart';
import 'package:baseapp/firebase_options.dart';
import 'package:baseapp/views/app/app_view.dart';
import 'package:baseapp/views/sign/create_account_view.dart';
import 'package:baseapp/views/sign/forgot_password_view.dart';
import 'package:baseapp/views/sign/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
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
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null && user.emailVerified) {
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
