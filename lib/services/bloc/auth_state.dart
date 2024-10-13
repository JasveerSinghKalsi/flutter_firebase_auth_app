import 'package:flutter/material.dart' show immutable;
import 'package:baseapp/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Loading',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateCreatingAccount extends AuthState {
  final Exception? exception;
  const AuthStateCreatingAccount({
    required super.isLoading,
    required this.exception,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required super.isLoading,
    required this.exception,
    super.loadingText,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required super.isLoading,
    required this.exception,
    required this.hasSentEmail,
  });
}
