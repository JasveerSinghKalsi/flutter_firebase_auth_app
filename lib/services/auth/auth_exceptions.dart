// Login
class InvalidCredentialsAuthException implements Exception {}

//Create Account
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generic
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
