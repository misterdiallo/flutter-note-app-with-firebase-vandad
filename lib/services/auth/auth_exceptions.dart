// ! Login Exceptions.

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// ! Registration Exceptions.

class EmailAlreadyUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class AuthException implements Exception {}

// ! Generic Exceptions.

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class UserDisabledAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class TooManyRequestAuthException implements Exception {}
