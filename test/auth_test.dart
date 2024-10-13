import 'package:flutter_test/flutter_test.dart';
import 'package:baseapp/services/auth/auth_exceptions.dart';
import 'package:baseapp/services/auth/auth_provider.dart';
import 'package:baseapp/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should be initialized tobegin with', () {
      expect(provider.isInititalized, false);
    });

    test('Cannot logout if not initialized', () {
      expect(
        provider.logout(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to initialized', () async {
      await provider.initialize();
      expect(provider.isInititalized, true);
    });

    test('User should be null after initialization', () async {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to login function', () async {
      final badCredentialUser =
          provider.createUser(email: 'abc@gmail.com', password: 'abc123');
      expect(
        badCredentialUser,
        throwsA(const TypeMatcher<InvalidCredentialsAuthException>()),
      );
      final user =
          await provider.createUser(email: 'email', password: 'password');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailverification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to logout and login again', () async {
      await provider.logout();
      await provider.login(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

    test('Should throw Invalid User if email is invalid', () async {
      expect(
        provider.sendPasswordReset(email: 'badEmail@gmail.com'),
        throwsA(const TypeMatcher<InvalidCredentialsAuthException>()),
      );
    });

    test('Should send password reset for a valid email', () async {
      await provider.initialize();
      await provider.sendPasswordReset(email: 'abc@gmail.com');
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInititalized => _isInitialized;

  AuthUser? _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInititalized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  Future<void> sendEmailverification() async {
    if (!isInititalized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInititalized) throw NotInitializedException();
    if (email == 'abc@gmail.com' || password == 'abc123') {
      throw InvalidCredentialsAuthException();
    }
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInititalized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    if (!isInititalized) throw NotInitializedException();
    if (email != 'abc@gmail.com') {
      throw InvalidCredentialsAuthException();
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}
