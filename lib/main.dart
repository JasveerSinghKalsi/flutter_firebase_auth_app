import 'package:flutter/material.dart';
import 'package:baseapp/services/auth/firebase_auth_provider.dart';
import 'package:baseapp/services/bloc/auth_bloc.dart';
import 'package:baseapp/services/bloc/auth_event.dart';
import 'package:baseapp/services/bloc/auth_state.dart';
import 'package:baseapp/utils/helpers/loading_screen.dart';
import 'package:baseapp/views/app/app_view.dart';
import 'package:baseapp/views/sign/create_account_view.dart';
import 'package:baseapp/views/sign/forgot_password_view.dart';
import 'package:baseapp/views/sign/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
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
      home: BlocProvider(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen()
              .show(context: context, text: state.loadingText ?? 'Loading');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        switch (state) {
          case AuthStateLoggedIn():
            return const AppView();
          case AuthStateNeedsVerification():
          case AuthStateLoggedOut():
            return const LoginView();
          case AuthStateCreatingAccount():
            return const CreateAccountView();
          case AuthStateForgotPassword():
            return const ForgotPasswordView();
          default:
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
