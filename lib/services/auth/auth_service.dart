//...
import 'package:my_notes/services/auth/auth_user.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/firebase_auth_provider.dart';
//...

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> createUserByEmail({
    required String name,
    required String email,
    required String password,
  }) =>
      provider.createUserByEmail(name: name, email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String username,
    required String password,
  }) =>
      provider.logIn(username: username, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> updateDisplayName(String name) =>
      provider.updateDisplayName(name);
}

// register function




