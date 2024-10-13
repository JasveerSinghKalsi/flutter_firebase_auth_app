import 'package:bloc/bloc.dart';
import 'package:baseapp/services/auth/auth_provider.dart';
import 'package:baseapp/services/bloc/auth_event.dart';
import 'package:baseapp/services/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(isLoading: false, exception: null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    //Create Account
    on<AuthEventCreateAccount>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailverification();
      } on Exception catch (e) {
        emit(AuthStateCreatingAccount(isLoading: false, exception: e));
      }
    });

    //Send email Verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailverification();
      emit(state);
    });

    //Login
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoggedOut(
        isLoading: true,
        exception: null,
        loadingText: 'Logging In',
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.login(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(isLoading: false, exception: null));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(isLoading: false, exception: null));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(isLoading: false, exception: e));
      }
    });
    //should create account
    on<AuthEventShouldCreateAccount>((event, emit) {
      emit(const AuthStateCreatingAccount(
        isLoading: false,
        exception: null,
      ));
    });

    //Logout
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut(isLoading: false, exception: null));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(isLoading: false, exception: e));
      }
    });

    //Forgot Password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        isLoading: false,
        exception: null,
        hasSentEmail: false,
      ));
      final email = event.email;
      if (email == null) {
        return;
      } else {
        emit(const AuthStateForgotPassword(
          isLoading: true,
          exception: null,
          hasSentEmail: false,
        ));
      }

      bool didSendEmail;
      Exception? exception;

      try {
        await provider.sendPasswordReset(email: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }
      emit(AuthStateForgotPassword(
        isLoading: false,
        exception: exception,
        hasSentEmail: didSendEmail,
      ));
    });
  }
}
