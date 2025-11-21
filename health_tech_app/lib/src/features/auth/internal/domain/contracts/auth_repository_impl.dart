import 'package:health_tech_app/src/features/auth/external/data/data_source/firebase_auth_datasource.dart';
import 'package:health_tech_app/src/features/auth/external/data/data_source/firebase_auth_datasource_impl.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/contracts/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasourceImpl datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<String> loginWithEmail(String email, String password) {
    return datasource.loginWithEmail(email, password);
  }

  @override
  Future<String> registerWithEmail(String email, String password) {
    return datasource.registerWithEmail(email, password);
  }

  @override
  Future<String> loginWithGoogle() {
    return datasource.loginWithGoogle();
  }

  @override
  Future<String> loginWithApple() {
    return datasource.loginWithApple();
  }

  @override
  Future<void> logout() {
    return datasource.logout();
  }

  @override
  Future<bool> isLoggedIn() {
    return datasource.isLoggedIn();
  }

  @override
  Future<String?> getCurrentUserId() {
    return datasource.getCurrentUserId();
  }
}
