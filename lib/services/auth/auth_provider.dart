import 'package:my_notes/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<void> initialize();
  Future<AuthUser> logIn({
    required String username,
    required String password,
  });
  Future<AuthUser> createUserByEmail({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> updateDisplayName(String name);
}
