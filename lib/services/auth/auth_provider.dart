import 'package:baseapp/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> sendEmailverification();

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordReset({required String email});
}
