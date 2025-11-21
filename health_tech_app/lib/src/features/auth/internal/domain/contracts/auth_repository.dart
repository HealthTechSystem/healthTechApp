abstract class AuthRepository {
  Future<String> loginWithEmail(String email, String password); // retorna uid
  Future<String> loginWithGoogle();
  Future<String> loginWithApple();
  Future<void> logout();
}