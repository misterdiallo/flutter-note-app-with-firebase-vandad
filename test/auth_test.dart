import 'package:flutter_test/flutter_test.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';

void main() {
  group('Mock Authentification', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with ', () {
      expect(provider._isInitialize, false);
    });
    test('Cannot logout if not initialized ', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializeException>()));
    });
    test('Should be able to initialize', () async {
      await provider.initialize();
      expect(provider._isInitialize, true);
    });
    test('User should be null after initialization', () async {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 second',
      () async {
        await provider.initialize();
        expect(provider._isInitialize, true);
      },
      timeout: const Timeout(
        Duration(seconds: 2),
      ),
    );

    test(
      'Create user should delegate to login function',
      () async {
        final badEmailUser = provider.createUserByEmail(
          name: "name",
          email: 'notemail@test.com',
          password: 'anypassword',
        );
        expect(
          badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()),
        );
        final badPasswordUser = provider.createUserByEmail(
          name: "name",
          email: 'anyemail@test.com',
          password: 'notpassword',
        );
        expect(
          badPasswordUser,
          throwsA(
            const TypeMatcher<WrongPasswordAuthException>(),
          ),
        );
        final user = await provider.createUserByEmail(
          name: "name",
          email: 'anyemail ',
          password: 'pass',
        );
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      },
    );

    test("Logged in user should be able to get verified", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to log out and log in", () async {
      await provider.logOut();
      await provider.logIn(username: "username", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialize = false;
  AuthUser? _user;
  bool get isInitialized => _isInitialize;

  @override
  Future<AuthUser> createUserByEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializeException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      username: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialize = true;
  }

  @override
  Future<AuthUser> logIn({
    required String username,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializeException();
    if (username == "notemail@test.com") throw UserNotFoundAuthException();
    if (password == "notpassword") throw WrongPasswordAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'notemail@test.com',
      id: 'my_id',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializeException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializeException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    const newUser = AuthUser(
      isEmailVerified: true,
      email: 'notemail@test.com',
      id: 'my_id',
    );
    _user = newUser;
  }

  @override
  Future<void> updateDisplayName(String name) async {
    if (!isInitialized) throw NotInitializeException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    // const newUser = AuthUser(isEmailVerified: true);
  }
}
