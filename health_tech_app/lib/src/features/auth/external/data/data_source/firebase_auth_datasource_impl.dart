import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthDatasourceImpl {
  final FirebaseAuth _auth;

  FirebaseAuthDatasourceImpl(this._auth);

  /// EMAIL & SENHA
  Future<String> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// REGISTRO EMAIL & SENHA
  Future<String> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// GOOGLE
  Future<String> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Login cancelado pelo usuário.');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user?.uid ?? '';
    } catch (e) {
      throw Exception('Erro ao logar com Google: $e');
    }
  }

  /// APPLE
  Future<String> loginWithApple() async {
    try {
      final appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await _auth.signInWithCredential(oauthCredential);

      return userCredential.user?.uid ?? '';
    } catch (e) {
      throw Exception('Erro ao logar com Apple: $e');
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut(); // evita usuário ficar travado no google
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  /// VERIFICA SE EXISTE USUÁRIO LOGADO
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  /// RETORNA UID OU NULL
  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }
}
