import 'package:baseapp/services/auth/auth_provider.dart';
import 'package:baseapp/services/auth/auth_user.dart';
import 'package:baseapp/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService({required this.provider});

  factory AuthService.firebase() =>
      AuthService(provider: FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailverification() => provider.sendEmailverification();

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendPasswordReset({required String email}) =>
      provider.sendPasswordReset(email: email);
}
