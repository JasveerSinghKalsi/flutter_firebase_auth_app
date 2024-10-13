import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventCreateAccount extends AuthEvent {
  final String email;
  final String password;
  const AuthEventCreateAccount({
    required this.email,
    required this.password,
  });
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventShouldCreateAccount extends AuthEvent {
  const AuthEventShouldCreateAccount();
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin({
    required this.email,
    required this.password,
  });
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
